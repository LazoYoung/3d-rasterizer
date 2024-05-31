#include "header/Triangle.cuh"

Triangle::Triangle() : Geometry(array, sizeof array) {}

void Triangle::draw() {
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}
