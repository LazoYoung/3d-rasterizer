#include "Camera.cuh"

Camera::Camera() : Camera(45.0f, 800.0f / 600.0f, 0.1f, 100.0f, 2.5f) {}

Camera::Camera(float fov, float aspectRatio, float zNear, float zFar, float speed) :
        _fov(fov),
        _aspect(aspectRatio),
        _zNear(zNear),
        _zFar(zFar),
        _speed(speed) {
    _transform.setPosition(0.0f, 0.0f, 3.0f);
    _transform.setRotation(0.0f, 0.0f, -1.0f);  // forward direction
    _transform.setUpdateCallback([this] { onTransform(); });
}

float Camera::getSpeed() const {
    return _speed;
}

const vec3 &Camera::getUpAxis() {
    return _up;
}

const vec3 &Camera::getRightAxis() {
    if (_right) {
        return *_right;
    }

    vec3 direction = _transform.getRotation();
    _right = new vec3();
    vec3 &right = *_right;
    right = glm::normalize(glm::cross(_up, direction));
    return right;
}

vec3 Camera::getForwardAxis() {
    return glm::normalize(_transform.getRotation());
}

mat4 &Camera::getProjection() {
    if (_projection) {
        return *_projection;
    }

    _projection = new mat4();
    mat4 &proj = *_projection;
    proj = glm::perspective(radians(_fov), _aspect, _zNear, _zFar);
    return proj;
}

mat4 &Camera::getView() {
    if (_view) {
        return *_view;
    }

    static auto unitX = vec3(1.0f, 0.0f, 0.0f);
    static auto unitY = vec3(0.0f, 1.0f, 0.0f);
    static auto unitZ = vec3(0.0f, 0.0f, 1.0f);
    auto &position = _transform.getPosition();
    auto &front = _transform.getRotation();
    _view = new mat4(1.0f);
    mat4 &view = *_view;
    view = glm::lookAt(position, position + front, _up);
    return view;
}

void Camera::move(vec3 velocity) {
    auto &pos = _transform.getPosition();
    float x = pos.x + velocity.x;
    float y = pos.y + velocity.y;
    float z = pos.z + velocity.z;
    _transform.setPosition(x, y, z);
}

void Camera::yaw(double degree) {
    _yaw += degree;

    updateDirection();
}

void Camera::pitch(double degree) {
    _pitch += degree;
    _pitch = clamp(_pitch, -89.0, 89.0);

    updateDirection();
}

void Camera::updateDirection() {
    auto x = static_cast<float>(cos(glm::radians(_yaw)) * cos(glm::radians(_pitch)));
    auto y = static_cast<float>(sin(glm::radians(_pitch)));
    auto z = static_cast<float>(sin(glm::radians(_yaw)) * cos(glm::radians(_pitch)));

    _transform.setRotation(x, y, z);
}

void Camera::onTransform() {
    if (_right) {
        free(_right);
        _right = nullptr;
    }

    if (_view) {
        free(_view);
        _view = nullptr;
    }

    if (_projection) {
        free(_projection);
        _projection = nullptr;
    }
}
