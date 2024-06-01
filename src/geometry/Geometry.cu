#include "Geometry.cuh"
#include "glm/glm.hpp"

Geometry::Geometry(GLfloat *vertexArray, GLsizeiptr vertexSize) :
        _vertexArray(vertexArray),
        _vertexSize(vertexSize) {
    _transform.setUpdateCallback([this] { resetModel(); });
}

void Geometry::bind() {
    if (_isBound) return;

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

void Geometry::render(Scene *scene) {
    bind();
    updateShader(scene);
    draw();
}

void Geometry::updateShader(Scene *scene) {
    auto &shader = scene->getShader();
    auto &camera = scene->getCamera();
    auto color = getColor();
    auto &model = getModel();
    auto &view = camera.getView();
    auto &projection = camera.getProjection();

    shader.setUniform("color", color.x, color.y, color.z, color.w);
    shader.setUniformMatrix(glUniformMatrix4fv, "model", false, model);
    shader.setUniformMatrix(glUniformMatrix4fv, "view", false, view);
    shader.setUniformMatrix(glUniformMatrix4fv, "projection", false, projection);
}

Transform &Geometry::getTransform() {
    return _transform;
}

mat4 &Geometry::getModel() {
    if (_model) {
        return *_model;
    }

    static auto unitX = vec3(1.0f, 0.0f, 0.0f);
    static auto unitY = vec3(0.0f, 1.0f, 0.0f);
    static auto unitZ = vec3(0.0f, 0.0f, 1.0f);
    auto &rotation = _transform.getRotation();
    _model = new mat4(1.0f);
    mat4 &model = *_model;
    model = glm::translate(model, _transform.getPosition());
    model = glm::rotate(model, radians(rotation.x), unitX);
    model = glm::rotate(model, radians(rotation.y), unitY);
    model = glm::rotate(model, radians(rotation.z), unitZ);
    model = glm::scale(model, _transform.getScale());
    return model;
}

void Geometry::resetModel() {
    if (_model) {
        free(_model);
        _model = nullptr;
    }
}
