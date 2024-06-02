#ifndef INC_3D_RASTERIZER_MODEL_CUH
#define INC_3D_RASTERIZER_MODEL_CUH


#include "Geometry.cuh"
#include "ModelVertex.cuh"
#include "ModelFace.cuh"

class Model : public Geometry {
public:
    Model(ModelVertex *vert, ModelFace *face);

    ~Model();

protected:
    void draw() override;

    void bind() override;

private:
    GLuint EBO = 0;
    ModelVertex *_vertex;
    ModelFace *_face;
};


#endif //INC_3D_RASTERIZER_MODEL_CUH
