#include "header/Transform.cuh"

Transform::Transform() :
        _position{0.0f},
        _rotation{0.0f},
        _scale{1.0f},
        _update(true) {}

mat4 Transform::getMatrix() {
    static auto unitX = vec3(1.0f, 0.0f, 0.0f);
    static auto unitY = vec3(0.0f, 1.0f, 0.0f);
    static auto unitZ = vec3(0.0f, 0.0f, 1.0f);
    mat4 trans = mat4(1.0f);
    trans = glm::translate(trans, _position);
    trans = glm::rotate(trans, radians(_rotation.x), unitX);
    trans = glm::rotate(trans, radians(_rotation.y), unitY);
    trans = glm::rotate(trans, radians(_rotation.z), unitZ);
    trans = glm::scale(trans, _scale);
    return trans;
}

vec3 Transform::getPosition() {
    return _position;
}

vec3 Transform::getRotation() {
    return _rotation;
}

vec3 Transform::getScale() {
    return _scale;
}

void Transform::move(float x, float y, float z) {
    _position.x = x;
    _position.y = y;
    _position.z = z;
    _update = true;
}

void Transform::rotate(float x, float y, float z) {
    _rotation.x = x;
    _rotation.y = y;
    _rotation.z = z;
    _update = true;
}

void Transform::scale(float x, float y, float z) {
    _scale.x = x;
    _scale.y = y;
    _scale.z = z;
    _update = true;
}

bool Transform::shouldUpdate() const {
    return _update;
}

void Transform::markUpdate() {
    _update = false;
}
