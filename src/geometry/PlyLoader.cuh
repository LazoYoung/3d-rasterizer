#ifndef INC_3D_RASTERIZER_PLYLOADER_CUH
#define INC_3D_RASTERIZER_PLYLOADER_CUH


#include <vector>
#include <string>
#include <unordered_map>
#include "Model.cuh"
#include "ModelVertex.cuh"
#include "ModelFace.cuh"

using namespace std;

class PlyLoader {
public:
    static Model importModel(const char *filePath, bool verbose = false);

private:
    static void readPlyFile(const char *path, ModelVertex &vert, ModelFace &face, bool verbose);

    static void processHeader(ifstream &file, ModelVertex &vert, ModelFace &face, bool &bakeNormals);

    static void processVertex(ifstream &file, ModelVertex &vert, bool bakeNormals, bool verbose);

    static void processFace(ifstream &file, ModelFace &face, bool verbose);

    static int getVertexPerFace(ifstream &file);

    static void bakeNormals(ModelVertex &vert, const ModelFace &face);
};


#endif //INC_3D_RASTERIZER_PLYLOADER_CUH
