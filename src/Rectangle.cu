#include "header/Rectangle.cuh"

Rectangle::Rectangle() : Geometry(_array, sizeof _array) {}

vec4 Rectangle::getColor() {
    auto time = static_cast<float>(glfwGetTime());
    float green = (sin(time) / 2.0f) + 0.5f;
    return {0.0f, green, 0.0f, 1.0f};
}

void Rectangle::bind() {
    Geometry::bind();

    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof _indices, _indices, GL_STATIC_DRAW);
}

void Rectangle::draw() {
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nullptr);
}
