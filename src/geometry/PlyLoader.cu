#include "PlyLoader.cuh"
#include "glm/glm.hpp"
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <iostream>
#include <algorithm>

Model PlyLoader::importModel(const char *filePath) {
    auto *vertexSet = new ModelVertex();
    auto *faceSet = new ModelFace();

    readPlyFile(filePath, *vertexSet, *faceSet);
    return {vertexSet, faceSet};
}

void PlyLoader::readPlyFile(const char *path, ModelVertex &vert, ModelFace &face) {
    ifstream file(path);

    if (!file.is_open()) {
        throw invalid_argument(string("Failed to open file: ").append(path));
    }

    cout << "Loading model: " << path << '\n';

    bool bakeNorms;
    processHeader(file, vert, face, bakeNorms);
    processVertex(file, vert, bakeNorms);
    processFace(file, face);

    if (bakeNorms) {
        bakeNormals(vert, face);
    }

    cout << "Found " << vert.count << " vertex points and " << face.count << " meshes." << endl;
}

void PlyLoader::processVertex(ifstream &file, ModelVertex &vert, bool bakeNormals) const {
    string line;
    int vertexIdx = 0;
    int keyCount = static_cast<int>(vert.keys.size());
    vert.arrayCount = vert.count * keyCount;
    vert.arraySize = vert.arrayCount * sizeof(GLfloat);
    vert.vertices = new GLfloat [vert.arrayCount];
    memset(vert.vertices, 0, vert.arraySize);

    while (getline(file, line)) {
        istringstream stream(line);

        for (int i = 0; i < keyCount; ++i) {
            if (bakeNormals && vert.keyIndex["nx"] <= i) {
                break;
            }

            GLfloat vertex;
            stream >> vertex;
            vert.vertices[vertexIdx * keyCount + i] = vertex;

            if (_verbose) {
                cout << vertex << ' ';
            }
        }

        if (_verbose) {
            cout << endl;
        }

        if (++vertexIdx >= vert.count) {
            break;
        }
    }
}

void PlyLoader::bakeNormals(ModelVertex &vert, const ModelFace &face) {
    switch (_device) {
        case CPU:
            bakeNormalsFromCPU(vert, face);
            break;
        case CUDA:
            bakeNormalsFromCUDA(vert, face);
            break;
    }
}

void PlyLoader::bakeNormalsFromCPU(ModelVertex &v, const ModelFace &f) {
    _profiler.startChrono();

    vector<vec3> normals(v.count);
    auto stride = v.keys.size();

    #pragma omp parallel for
    for (int tID = 0; tID < f.count; ++tID) {
        auto v1 = f.indices[tID * 3];
        auto v2 = f.indices[tID * 3 + 1];
        auto v3 = f.indices[tID * 3 + 2];
        vec3 A = vec3(v.vertices[v1 * stride], v.vertices[v1 * stride + 1], v.vertices[v1 * stride + 2]);
        vec3 B = vec3(v.vertices[v2 * stride], v.vertices[v2 * stride + 1], v.vertices[v2 * stride + 2]);
        vec3 C = vec3(v.vertices[v3 * stride], v.vertices[v3 * stride + 1], v.vertices[v3 * stride + 2]);

        // Cross product on 2 vectors that form a polygon
        vec3 normal = glm::cross(B - A, C - A);

        // Accumulate normals per vertex
        #pragma omp critical
        {
            normals[v1] += normal;
            normals[v2] += normal;
            normals[v3] += normal;
        }
    }

    for (int i = 0; i < v.count; ++i) {
        // Every normal is a unit vector
        vec3 normal = glm::normalize(normals[i]);

        // Assign to vertex array (presuming `nx` key maps to index 3)
        v.vertices[i * stride + 3] = normal.x;
        v.vertices[i * stride + 4] = normal.y;
        v.vertices[i * stride + 5] = normal.z;
    }

    cout << "CPU took " << _profiler.getElapsed() << " milliseconds to bake mesh normals." << endl;
}

__global__ void computeNormalsKernel(float *vertices, const unsigned int *indices, vec3 *normals, int faceCount, int stride) {
    auto tID = blockIdx.x * blockDim.x + threadIdx.x;

    if (tID >= faceCount) return;

    auto v1 = indices[tID * 3];
    auto v2 = indices[tID * 3 + 1];
    auto v3 = indices[tID * 3 + 2];
    vec3 A = vec3(vertices[v1 * stride], vertices[v1 * stride + 1], vertices[v1 * stride + 2]);
    vec3 B = vec3(vertices[v2 * stride], vertices[v2 * stride + 1], vertices[v2 * stride + 2]);
    vec3 C = vec3(vertices[v3 * stride], vertices[v3 * stride + 1], vertices[v3 * stride + 2]);

    // Cross product on 2 vectors that form a polygon
    vec3 normal = cross(B - A, C - A);

    // Accumulate normal of vertex #1
    atomicAdd(&normals[v1].x, normal.x);
    atomicAdd(&normals[v1].y, normal.y);
    atomicAdd(&normals[v1].z, normal.z);

    // Accumulate normal of vertex #2
    atomicAdd(&normals[v2].x, normal.x);
    atomicAdd(&normals[v2].y, normal.y);
    atomicAdd(&normals[v2].z, normal.z);

    // Accumulate normal of vertex #3
    atomicAdd(&normals[v3].x, normal.x);
    atomicAdd(&normals[v3].y, normal.y);
    atomicAdd(&normals[v3].z, normal.z);
}

__global__ void normalizeNormalsKernel(float* vertices, const vec3* normals, int vertexCount, int stride) {
    auto tID = blockIdx.x * blockDim.x + threadIdx.x;

    if (tID >= vertexCount) return;

    // Every normal is a unit vector
    vec3 normal = glm::normalize(normals[tID]);

    // Assign to vertex array (presuming `nx` key maps to index 3)
    vertices[tID * stride + 3] = normal.x;
    vertices[tID * stride + 4] = normal.y;
    vertices[tID * stride + 5] = normal.z;
}

void PlyLoader::bakeNormalsFromCUDA(ModelVertex &v, const ModelFace &f) {
    int vertexCount = v.count;
    int faceCount = f.count;
    int stride = static_cast<int>(v.keys.size());

    // Allocate device memory
    float* d_vertices;
    unsigned int* d_indices;
    vec3* d_normals;
    cudaMalloc(&d_vertices, vertexCount * stride * sizeof(float));
    cudaMalloc(&d_indices, faceCount * 3 * sizeof(unsigned int));
    cudaMalloc(&d_normals, vertexCount * sizeof(vec3));
    cudaMemcpy(d_vertices, v.vertices, vertexCount * stride * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_indices, f.indices, faceCount * 3 * sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemset(d_normals, 0, vertexCount * sizeof(vec3));

    int blockSize = 256;
    int numBlocksFace = (faceCount + blockSize - 1) / blockSize;
    int numBlocksVertex = (vertexCount + blockSize - 1) / blockSize;

    _profiler.startChrono();

    computeNormalsKernel<<<numBlocksFace, blockSize>>>(d_vertices, d_indices, d_normals, faceCount, stride);
    cudaDeviceSynchronize();

    normalizeNormalsKernel<<<numBlocksVertex, blockSize>>>(d_vertices, d_normals, vertexCount, stride);
    cudaDeviceSynchronize();

    cout << "CUDA took " << _profiler.getElapsed() << " milliseconds to bake mesh normals." << endl;

    // Copy result to host memory
    cudaMemcpy(v.vertices, d_vertices, vertexCount * stride * sizeof(float), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_vertices);
    cudaFree(d_indices);
    cudaFree(d_normals);
}

void PlyLoader::processFace(ifstream &file, ModelFace &face) const {
    string line;
    int faceIdx = 0;
    face.vertexPerFace = getVertexPerFace(file);
    face.arrayCount = face.count * face.vertexPerFace;
    face.arraySize = face.arrayCount * sizeof(GLfloat);
    face.indices = new GLuint [face.arrayCount];
    bool firstLine = true;

    while (getline(file, line)) {
        string firstToken;
        istringstream stream(line);

        if (!firstLine) {
            stream >> firstToken;

            if (stoi(firstToken) != face.vertexPerFace) {
                throw runtime_error("Inconsistent vertex indices!");
            }
        }

        firstLine = false;

        if (_verbose) {
            cout << firstToken << ' ';
        }

        for (int i = 0; i < face.vertexPerFace; ++i) {
            int vertexIndex;
            stream >> vertexIndex;
            face.indices[faceIdx * face.vertexPerFace + i] = vertexIndex;

            if (_verbose) {
                cout << vertexIndex << ' ';
            }
        }

        if (_verbose) {
            cout << '\n';
        }

        if (++faceIdx >= face.count) {
            break;
        }
    }
}

void PlyLoader::processHeader(ifstream &file, ModelVertex &vert, ModelFace &face, bool &bakeNormals) const {
    string line;
    string element;
    int keyIdx = 0;

    while (getline(file, line)) {
        if (line == "end_header") {
            break;
        }

        istringstream lineStream(line);
        string label;

        getline(lineStream, label, ' ');

        if (label == "ply" || label == "format") {
            continue;
        }

        if (label == "element") {
            string count;
            getline(lineStream, element, ' ');
            getline(lineStream, count, ' ');

            if (element == "vertex") {
                vert.count = stoi(count);
            } else if (element == "face") {
                face.count = stoi(count);
            } else {
                throw runtime_error(string("Bad element: ").append(element));
            }

            continue;
        }

        if (label == "property") {
            if (element == "vertex") {
                string dType;
                string dLabel;

                getline(lineStream, dType, ' ');
                getline(lineStream, dLabel, ' ');

                vert.keys.push_back(dLabel);
                vert.keyIndex.insert(pair(dLabel, keyIdx++));
            }

            continue;
        }
    }

    auto &keys = vert.keys;
    bool normalFound = std::find(keys.begin(), keys.end(), "nx") != keys.end();
    bakeNormals = _bakeNorms && !normalFound;
    vert.hasNormals = bakeNormals || normalFound;

    if (bakeNormals) {
        keys.emplace_back("nx");
        vert.keyIndex.insert(pair("nx", keyIdx++));
        keys.emplace_back("ny");
        vert.keyIndex.insert(pair("ny", keyIdx++));
        keys.emplace_back("nz");
        vert.keyIndex.insert(pair("nz", keyIdx++));
    }
}

int PlyLoader::getVertexPerFace(ifstream &file) {
    string str;
    file >> str;
    return stoi(str);
}
