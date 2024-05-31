#ifndef GAUSSIAN_RASTERIZER_TRIANGLE_CUH
#define GAUSSIAN_RASTERIZER_TRIANGLE_CUH


#include "Geometry.cuh"
#include "../../include/glm/vec4.hpp"

class Triangle : public Geometry {
public:
    Triangle();

private:
    vec4 getColor() override;

private:
    GLfloat array[9]{
            -0.1f, -0.1f, 0.0f,
            0.1f, -0.1f, 0.0f,
            0.0f, 0.1f, 0.0f
    };
};


#endif //GAUSSIAN_RASTERIZER_TRIANGLE_CUH
