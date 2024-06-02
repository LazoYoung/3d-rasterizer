#ifndef INC_3D_RASTERIZER_MODEL_CUH
#define INC_3D_RASTERIZER_MODEL_CUH


#include "Geometry.cuh"
#include "VertexSet.cuh"
#include "FaceSet.cuh"

class Model : public Geometry {
public:
    Model(VertexSet *vert, FaceSet *face);

    ~Model();

protected:
    void draw() override;

    void bind() override;

private:
    GLuint EBO = 0;
    VertexSet *_vertexSet;
    FaceSet *_faceSet;
};


#endif //INC_3D_RASTERIZER_MODEL_CUH
