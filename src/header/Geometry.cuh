#ifndef GAUSSIAN_RASTERIZER_GEOMETRY_CUH
#define GAUSSIAN_RASTERIZER_GEOMETRY_CUH


#include "Shader.cuh"
#include "Transform.cuh"

class Geometry {
public:
    Geometry(GLfloat *vertexArray, GLsizeiptr vertexSize);

    void render(const Shader &shader);

    Transform &getTransform();

    virtual vec4 getColor();

protected:
    GLfloat *_vertexArray;
    GLsizeiptr _vertexSize;
    GLuint VAO = 0;
    GLuint VBO = 0;

    virtual void bind();

    virtual void draw() = 0;

private:
    Transform _transform;
    bool _isBound = false;

    void checkBound();

    void updateShader(const Shader &shader);
};


#endif //GAUSSIAN_RASTERIZER_GEOMETRY_CUH
