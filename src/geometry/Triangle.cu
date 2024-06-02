#include "Triangle.cuh"

Triangle::Triangle() : Geometry(_array, sizeof _array, 3) {}

void Triangle::draw() {
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}
