#include "Cube.cuh"

Cube::Cube() : Geometry(_array, sizeof _array, _count) {}

void Cube::bind(Pipeline pipeline) {
    Geometry::bind(pipeline);

    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof _indices, _indices, GL_STATIC_DRAW);
}

void Cube::draw() {
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, _count, GL_UNSIGNED_INT, nullptr);
}
