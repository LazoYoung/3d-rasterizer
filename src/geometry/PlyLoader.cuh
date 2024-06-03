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
    explicit PlyLoader(bool bakeNormals = true, bool verbose = false) :
            _bakeNorms(bakeNormals), _verbose(verbose) {}

    Model importModel(const char *filePath);

private:
    bool _verbose;
    bool _bakeNorms;

    void readPlyFile(const char *path, ModelVertex &vert, ModelFace &face);

    void processHeader(ifstream &file, ModelVertex &vert, ModelFace &face, bool &bakeNormals) const;

    void processVertex(ifstream &file, ModelVertex &vert, bool bakeNormals) const;

    void processFace(ifstream &file, ModelFace &face) const;

    static int getVertexPerFace(ifstream &file);

    static void bakeNormals(ModelVertex &vert, const ModelFace &face);
};


#endif //INC_3D_RASTERIZER_PLYLOADER_CUH
