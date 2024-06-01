#ifndef GAUSSIAN_RASTERIZER_CUBE_CUH
#define GAUSSIAN_RASTERIZER_CUBE_CUH


#include "Geometry.cuh"

class Cube : public Geometry {
public:
    Cube();

protected:
    void bind() override;

    void draw() override;

private:
    static const GLsizei _count = 36;
    constexpr static const GLfloat _array[24]{
            // front
            -0.1f, 0.1f, 0.1f,     // 0
            0.1f, 0.1f, 0.1f,      // 1
            0.1f, -0.1f, 0.1f,     // 2
            -0.1f, -0.1f, 0.1f,   // 3
            // back
            -0.1f, 0.1f, -0.1f,  // 4
            0.1f, 0.1f, -0.1f,   // 5
            0.1f, -0.1f, -0.1f,  // 6
            -0.1f, -0.1f, -0.1f  // 7
    };
    constexpr static const GLint _indices[_count]{
            // front
            0, 1, 2,
            2, 3, 0,
            // back
            4, 5, 6,
            6, 7, 4,
            // left
            0, 4, 7,
            7, 3, 0,
            // right
            1, 5, 6,
            6, 2, 1,
            // top
            0, 4, 5,
            5, 1, 0,
            // bottom
            3, 7, 4,
            4, 0, 3
    };
    GLuint EBO = 0;
};


#endif //GAUSSIAN_RASTERIZER_CUBE_CUH
