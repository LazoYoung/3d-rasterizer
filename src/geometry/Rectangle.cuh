#ifndef GAUSSIAN_RASTERIZER_RECTANGLE_CUH
#define GAUSSIAN_RASTERIZER_RECTANGLE_CUH


#include "Geometry.cuh"

class Rectangle : public Geometry {
public:
    Rectangle();
    vec4 getColor() override;

protected:
    void bind() override;

    void draw() override;

private:
    GLfloat _array[12]{
            -0.1f, 0.1f, 0.0f,
            0.1f, 0.1f, 0.0f,
            0.1f, -0.1f, 0.0f,
            -0.1f, -0.1f, 0.0f
    };
    GLint _indices[6]{
        0, 1, 2,
        2, 3, 0
    };
    GLuint EBO = 0;
};


#endif //GAUSSIAN_RASTERIZER_RECTANGLE_CUH
