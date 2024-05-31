#include "header/Triangle.cuh"

Triangle::Triangle() : Geometry(array, sizeof array) {}

vec4 Triangle::getColor() {
    auto time = static_cast<float>(glfwGetTime());
    float green = (sin(time) / 2.0f) + 0.5f;
    return {0.0f, green, 0.0f, 1.0f};
}
