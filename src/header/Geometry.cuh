#ifndef GAUSSIAN_RASTERIZER_GEOMETRY_CUH
#define GAUSSIAN_RASTERIZER_GEOMETRY_CUH


#include "Shader.cuh"
#include "Transform.cuh"

class Geometry {
public:
    Geometry(GLfloat *vertexArray, GLsizeiptr vertexSize);

    void draw(const Shader &shader);

    Transform &getTransform();

protected:
    GLfloat *vertexArray;
    GLsizeiptr vertexSize;

private:
    Transform transform;
    bool isBound = false;
    GLuint VAO = 0;
    GLuint VBO = 0;

    void bind();

    virtual vec4 getColor();
};


#endif //GAUSSIAN_RASTERIZER_GEOMETRY_CUH
