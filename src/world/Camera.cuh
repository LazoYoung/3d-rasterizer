#ifndef GAUSSIAN_RASTERIZER_CAMERA_CUH
#define GAUSSIAN_RASTERIZER_CAMERA_CUH


#include "Transform.cuh"

class Camera {
public:
    Camera();

    Camera(float fov, float aspectRatio, float zNear, float zFar);

    mat4 &getView();

    mat4 &getProjection();

private:
    Transform _transform;
    mat4 *_view = nullptr;
    mat4 *_projection = nullptr;
    float _fov;
    float _aspect;
    float _zNear;
    float _zFar;

    void onTransform();
};


#endif //GAUSSIAN_RASTERIZER_CAMERA_CUH
