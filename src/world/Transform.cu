#include "Transform.cuh"

Transform::Transform() :
        _position{0.0f},
        _rotation{0.0f},
        _scale{1.0f} {}

const vec3 &Transform::getPosition() {
    return _position;
}

const vec3 &Transform::getRotation() {
    return _rotation;
}

const vec3 &Transform::getScale() {
    return _scale;
}

void Transform::move(float x, float y, float z) {
    _position.x = x;
    _position.y = y;
    _position.z = z;
    notify();
}

void Transform::rotate(float x, float y, float z) {
    _rotation.x = x;
    _rotation.y = y;
    _rotation.z = z;
    notify();
}

void Transform::scale(float x, float y, float z) {
    _scale.x = x;
    _scale.y = y;
    _scale.z = z;
    notify();
}

void Transform::setUpdateCallback(const std::function<void()>& callback) {
    _callback = callback;
}

void Transform::notify() {
    if (_callback) {
        _callback();
    }
}
