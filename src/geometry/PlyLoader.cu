#include "PlyLoader.cuh"
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <string>
#include <iostream>

Model PlyLoader::importModel(const char *filePath, bool verbose) {
    auto *vertexSet = new VertexSet();
    auto *faceSet = new FaceSet();

    readPlyFile(filePath, *vertexSet, *faceSet, verbose);
    return {vertexSet, faceSet};
}

void PlyLoader::readPlyFile(const char *path, VertexSet &vertexSet, FaceSet &faceSet, bool verbose) {
    ifstream file(path);

    if (!file.is_open()) {
        throw invalid_argument(string("Failed to open file: ").append(path));
    }

    cout << "Loading model: " << path << '\n';

    processHeader(file, vertexSet, faceSet);
    processVertex(file, vertexSet, verbose);
    processFace(file, faceSet, verbose);

    cout << "Found " << vertexSet.count << " vertex points and " << faceSet.count << " meshes." << endl;
}

void PlyLoader::processVertex(ifstream &file, VertexSet &vertexSet, bool verbose) {
    string line;
    int vertexIdx = 0;
    int keyCount = static_cast<int>(vertexSet.keys.size());
    vertexSet.arrayCount = vertexSet.count * keyCount;
    vertexSet.arraySize = vertexSet.arrayCount * sizeof(GLfloat);
    vertexSet.vertices = new GLfloat [vertexSet.arrayCount];

    while (getline(file, line)) {
        istringstream stream(line);

        for (int i = 0; i < keyCount; ++i) {
            GLfloat vertex;
            stream >> vertex;
            vertexSet.vertices[vertexIdx * keyCount + i] = vertex;

            if (verbose) {
                cout << vertex << ' ';
            }
        }

        if (verbose) {
            cout << endl;
        }

        if (++vertexIdx >= vertexSet.count) {
            break;
        }
    }
}

void PlyLoader::processFace(ifstream &file, FaceSet &faceSet, bool verbose) {
    string line;
    int faceIdx = 0;
    faceSet.vertexPerFace = getVertexPerFace(file);
    faceSet.arrayCount = faceSet.count * faceSet.vertexPerFace;
    faceSet.arraySize = faceSet.arrayCount * sizeof(GLfloat);
    faceSet.indices = new GLuint [faceSet.arrayCount];
    bool firstLine = true;

    while (getline(file, line)) {
        string firstToken;
        istringstream stream(line);

        if (!firstLine) {
            stream >> firstToken;

            if (stoi(firstToken) != faceSet.vertexPerFace) {
                throw runtime_error("Inconsistent vertex indices!");
            }
        }

        firstLine = false;

        if (verbose) {
            cout << firstToken << ' ';
        }

        for (int i = 0; i < faceSet.vertexPerFace; ++i) {
            int vertexIndex;
            stream >> vertexIndex;
            faceSet.indices[faceIdx * faceSet.vertexPerFace + i] = vertexIndex;

            if (verbose) {
                cout << vertexIndex << ' ';
            }
        }

        if (verbose) {
            cout << '\n';
        }

        if (++faceIdx >= faceSet.count) {
            break;
        }
    }
}

void PlyLoader::processHeader(ifstream &file, VertexSet &vertexSet, FaceSet &faceSet) {
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
                vertexSet.count = stoi(count);
            } else if (element == "face") {
                faceSet.count = stoi(count);
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

                vertexSet.keys.push_back(dLabel);
                vertexSet.keyIndex.insert(pair(dLabel, keyIdx++));
            }
        }
    }
}

int PlyLoader::getVertexPerFace(ifstream &file) {
    string str;
    file >> str;
    return stoi(str);
}
