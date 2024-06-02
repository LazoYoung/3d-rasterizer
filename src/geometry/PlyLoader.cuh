#ifndef INC_3D_RASTERIZER_PLYLOADER_CUH
#define INC_3D_RASTERIZER_PLYLOADER_CUH


#include <vector>
#include <string>
#include <unordered_map>
#include "Model.cuh"
#include "VertexSet.cuh"
#include "FaceSet.cuh"

using namespace std;

class PlyLoader {
public:
    static Model importModel(const char *filePath, bool verbose = false);

private:
    static void readPlyFile(const char *path, VertexSet &vertexSet, FaceSet &faceSet, bool verbose);

    static void processHeader(ifstream &file, VertexSet &vertexSet, FaceSet &faceSet);

    static void processVertex(ifstream &file, VertexSet &vertexSet, bool verbose);

    static void processFace(ifstream &file, FaceSet &faceSet, bool verbose);

    static int getVertexPerFace(ifstream &file);
};


#endif //INC_3D_RASTERIZER_PLYLOADER_CUH
