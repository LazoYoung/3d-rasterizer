#include "header/Geometry.cuh"
#include <glm/glm.hpp>

Geometry::Geometry(const Shader &shader) : shader(shader) {
    float vertices[9] = {
            -0.1f, -0.1f, 0.0f,
            0.1f, -0.1f, 0.0f,
            0.0f, 0.1f, 0.0f
    };

    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof vertices, vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), nullptr);
    glEnableVertexAttribArray(0);
}

void Geometry::draw() {
    auto time = static_cast<float>(glfwGetTime());
    float green = (sin(time) / 2.0f) + 0.5f;
    shader.useProgram();
    shader.setUniform("color", (GLfloat) 0.0f, (GLfloat) green, (GLfloat) 0.0f, (GLfloat) 1.0f);

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
