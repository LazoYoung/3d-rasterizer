#include "Geometry.cuh"
#include "glm/glm.hpp"

Geometry::Geometry(GLfloat *vertexArray, GLsizeiptr vertexSize) :
        _vertexArray(vertexArray),
        _vertexSize(vertexSize) {}

void Geometry::bind() {
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, _vertexSize, _vertexArray, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), nullptr);
    glEnableVertexAttribArray(0);
}

vec4 Geometry::getColor() {
    return {0.0f, 0.0f, 0.0f, 1.0f};
}

void Geometry::render(const Shader &shader) {
    checkBound();
    updateShader(shader);
    draw();
}

void Geometry::checkBound() {
    if (!_isBound) {
        bind();
        _isBound = true;
    }
}

void Geometry::updateShader(const Shader &shader) {
    vec4 color = getColor();
    mat4 transform = _transform.getMatrix();

    shader.setUniform("color", color.x, color.y, color.z, color.w);
    shader.setUniformMatrix(glUniformMatrix4fv, "transform", false, transform);
}

Transform &Geometry::getTransform() {
    return _transform;
}
