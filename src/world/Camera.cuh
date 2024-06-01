#ifndef GAUSSIAN_RASTERIZER_CAMERA_CUH
#define GAUSSIAN_RASTERIZER_CAMERA_CUH


#include "Transform.cuh"

class Camera {
public:
    Camera();

    Camera(float fov, float aspectRatio, float zNear, float zFar, float speed);

    float getSpeed() const;

    const vec3 &getUpAxis();

    const vec3 &getRightAxis();

    vec3 getForwardAxis();

    mat4 &getView();

    mat4 &getProjection();

    void move(vec3 velocity);

    void yaw(double degree);

    void pitch(double degree);

private:
    Transform _transform;
    vec3 _up = vec3(0.0f, 1.0f, 0.0f);
    vec3 *_right = nullptr;
    mat4 *_view = nullptr;
    mat4 *_projection = nullptr;
    double _yaw = -90.0;
    double _pitch = 0.0;
    float _fov;
    float _aspect;
    float _zNear;
    float _zFar;
    float _speed;

    void updateDirection();

    void onTransform();
};


#endif //GAUSSIAN_RASTERIZER_CAMERA_CUH
