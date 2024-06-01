#include "Camera.cuh"

Camera::Camera() : Camera(45.0f, 800.0f / 600.0f, 0.1f, 100.0f) {}

Camera::Camera(float fov, float aspectRatio, float zNear, float zFar) :
        _fov(fov),
        _aspect(aspectRatio),
        _zNear(zNear),
        _zFar(zFar) {
    _transform.move(0.0f, 0.0f, 3.0f);
    _transform.setUpdateCallback([this] { onTransform(); });
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
    auto &rotation = _transform.getRotation();
    _view = new mat4(1.0f);
    mat4 &view = *_view;
    view = glm::translate(view, -1.0f * position);
    view = glm::rotate(view, radians(-rotation.x), unitX);
    view = glm::rotate(view, radians(-rotation.y), unitY);
    view = glm::rotate(view, radians(-rotation.z), unitZ);
    return view;
}

void Camera::onTransform() {
    if (_view) {
        free(_view);
        _view = nullptr;
    }

    if (_projection) {
        free(_projection);
        _projection = nullptr;
    }
}
