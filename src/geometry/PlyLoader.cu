#include "PlyLoader.cuh"
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
    vector<vec3> normals(vert.count);
    auto stride = vert.keys.size();

#pragma omp parallel for
    for (int i = 0; i < face.count; ++i) {
        auto i1 = face.indices[i * 3];
        auto i2 = face.indices[i * 3 + 1];
        auto i3 = face.indices[i * 3 + 2];
        vec3 x = vec3(vert.vertices[i1 * stride], vert.vertices[i1 * stride + 1], vert.vertices[i1 * stride + 2]);
        vec3 y = vec3(vert.vertices[i2 * stride], vert.vertices[i2 * stride + 1], vert.vertices[i2 * stride + 2]);
        vec3 z = vec3(vert.vertices[i3 * stride], vert.vertices[i3 * stride + 1], vert.vertices[i3 * stride + 2]);
        vec3 normal = glm::cross(y - x, z - x);

#pragma omp critical
        {
            normals[i1] += normal;
            normals[i2] += normal;
            normals[i3] += normal;
        }
    }

    for (int i = 0; i < vert.count; ++i) {
        vec3 normal = glm::normalize(normals[i]);

        vert.vertices[i * stride + 3] = normal.x;
        vert.vertices[i * stride + 4] = normal.y;
        vert.vertices[i * stride + 5] = normal.z;
    }
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
