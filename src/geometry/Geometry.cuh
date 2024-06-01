#ifndef GAUSSIAN_RASTERIZER_GEOMETRY_CUH
#define GAUSSIAN_RASTERIZER_GEOMETRY_CUH


#include "../Shader.cuh"
#include "../world/Transform.cuh"
#include "../world/Scene.cuh"

class Scene;

class Geometry {
public:
    Geometry(GLfloat *vertexArray, GLsizeiptr vertexSize);

    void render(Scene *scene);

    Transform &getTransform();

    mat4 &getModel();

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
    mat4 *_model = nullptr;

    void resetModel();

    void updateShader(Scene *scene);
};


#endif //GAUSSIAN_RASTERIZER_GEOMETRY_CUH
