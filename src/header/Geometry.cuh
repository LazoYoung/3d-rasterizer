#ifndef GAUSSIAN_RASTERIZER_GEOMETRY_CUH
#define GAUSSIAN_RASTERIZER_GEOMETRY_CUH


#include "Shader.cuh"
#include "Transform.cuh"

class Geometry {
public:
    explicit Geometry(const Shader &shader);

    void draw();

    Transform &getTransform();

private:
    Transform transform;
    Shader shader;
    GLuint VAO = 0;
    GLuint VBO = 0;
};


#endif //GAUSSIAN_RASTERIZER_GEOMETRY_CUH
