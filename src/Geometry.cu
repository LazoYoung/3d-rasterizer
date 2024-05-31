#include "header/Geometry.cuh"
#include <glm/glm.hpp>

Geometry::Geometry(GLfloat *vertexArray, GLsizeiptr vertexSize) :
        vertexArray(vertexArray),
        vertexSize(vertexSize) {}

void Geometry::bind() {

    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, vertexSize, vertexArray, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), nullptr);
    glEnableVertexAttribArray(0);
}

vec4 Geometry::getColor() {
    return {0.0f, 0.0f, 0.0f, 1.0f};
}

void Geometry::draw(const Shader &shader) {
    if (!isBound) {
        bind();
        isBound = true;
    }

    shader.useProgram();

    vec4 color = getColor();
    shader.setUniform("color", color.x, color.y, color.z, color.w);

    if (transform.shouldUpdate()) {
        shader.setUniformMatrix(glUniformMatrix4fv, "transform", false, transform.getMatrix());
        transform.markUpdate();
    }

    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

Transform &Geometry::getTransform() {
    return transform;
}
