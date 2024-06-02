#include "PlyLoader.cuh"
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <iostream>

Model PlyLoader::importModel(const char *filePath, bool verbose) {
    auto *vertexSet = new ModelVertex();
    auto *faceSet = new ModelFace();

    readPlyFile(filePath, *vertexSet, *faceSet, verbose);
    return {vertexSet, faceSet};
}

void PlyLoader::readPlyFile(const char *path, ModelVertex &vert, ModelFace &face, bool verbose) {
    ifstream file(path);

    if (!file.is_open()) {
        throw invalid_argument(string("Failed to open file: ").append(path));
    }

    cout << "Loading model: " << path << '\n';

    processHeader(file, vert, face);
    processVertex(file, vert, verbose);
    processFace(file, face, verbose);

    cout << "Found " << vert.count << " vertex points and " << face.count << " meshes." << endl;
}

void PlyLoader::processVertex(ifstream &file, ModelVertex &vert, bool verbose) {
    string line;
    int vertexIdx = 0;
    int keyCount = static_cast<int>(vert.keys.size());
    vert.arrayCount = vert.count * keyCount;
    vert.arraySize = vert.arrayCount * sizeof(GLfloat);
    vert.vertices = new GLfloat [vert.arrayCount];

    while (getline(file, line)) {
        istringstream stream(line);

        for (int i = 0; i < keyCount; ++i) {
            GLfloat vertex;
            stream >> vertex;
            vert.vertices[vertexIdx * keyCount + i] = vertex;

            if (verbose) {
                cout << vertex << ' ';
            }
        }

        if (verbose) {
            cout << endl;
        }

        if (++vertexIdx >= vert.count) {
            break;
        }
    }
}

void PlyLoader::processFace(ifstream &file, ModelFace &face, bool verbose) {
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

        if (verbose) {
            cout << firstToken << ' ';
        }

        for (int i = 0; i < face.vertexPerFace; ++i) {
            int vertexIndex;
            stream >> vertexIndex;
            face.indices[faceIdx * face.vertexPerFace + i] = vertexIndex;

            if (verbose) {
                cout << vertexIndex << ' ';
            }
        }

        if (verbose) {
            cout << '\n';
        }

        if (++faceIdx >= face.count) {
            break;
        }
    }
}

void PlyLoader::processHeader(ifstream &file, ModelVertex &vert, ModelFace &face) {
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
        }
    }
}

int PlyLoader::getVertexPerFace(ifstream &file) {
    string str;
    file >> str;
    return stoi(str);
}
