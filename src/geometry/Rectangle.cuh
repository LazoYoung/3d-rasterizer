#ifndef GAUSSIAN_RASTERIZER_RECTANGLE_CUH
#define GAUSSIAN_RASTERIZER_RECTANGLE_CUH


#include "Geometry.cuh"

class Rectangle : public Geometry {
public:
    Rectangle();
    vec3 getColor() override;

protected:
    void bind(Pipeline pipeline) override;

    void draw() override;

private:
    static const GLsizei _count = 6;
    constexpr static const GLfloat _array[12]{
            -0.1f, 0.1f, 0.0f,
            0.1f, 0.1f, 0.0f,
            0.1f, -0.1f, 0.0f,
            -0.1f, -0.1f, 0.0f
    };
    constexpr static const GLint _indices[_count]{
        0, 1, 2,
        2, 3, 0
    };
    GLuint EBO = 0;
};


#endif //GAUSSIAN_RASTERIZER_RECTANGLE_CUH
