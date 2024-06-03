#ifndef INC_3D_RASTERIZER_PLYLOADER_CUH
#define INC_3D_RASTERIZER_PLYLOADER_CUH


#include <vector>
#include <string>
#include <unordered_map>
#include "Model.cuh"
#include "ModelVertex.cuh"
#include "ModelFace.cuh"
#include "../Profiler.cuh"

using namespace std;

class PlyLoader {
public:
    PlyLoader(Device device, bool bakeNormals, bool verbose = false) :
            _device(device), _bakeNorms(bakeNormals), _verbose(verbose) {}

    Model importModel(const char *filePath);

private:
    Profiler _profiler;
    Device _device;
    bool _verbose;
    bool _bakeNorms;

    void readPlyFile(const char *path, ModelVertex &vert, ModelFace &face);

    void processHeader(ifstream &file, ModelVertex &vert, ModelFace &face, bool &bakeNormals) const;

    void processVertex(ifstream &file, ModelVertex &vert, bool bakeNormals) const;

    void processFace(ifstream &file, ModelFace &face) const;

    void bakeNormals(ModelVertex &vert, const ModelFace &face);

    void bakeNormalsFromCPU(ModelVertex &v, const ModelFace &f);

    void bakeNormalsFromCUDA(ModelVertex &v, const ModelFace &f);

    static int getVertexPerFace(ifstream &file);
};


#endif //INC_3D_RASTERIZER_PLYLOADER_CUH
