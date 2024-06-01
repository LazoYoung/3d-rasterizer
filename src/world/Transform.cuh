#ifndef GAUSSIAN_RASTERIZER_TRANSFORM_CUH
#define GAUSSIAN_RASTERIZER_TRANSFORM_CUH

#include "glm/glm.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"
#include <functional>

using namespace glm;

class Transform {
public:
    Transform();

    const vec3 &getPosition();

    const vec3 &getRotation();

    const vec3 &getScale();

    void move(float x, float y, float z);

    void rotate(float x, float y, float z);

    void scale(float x, float y, float z);

    void setUpdateCallback(const std::function<void()>& callback);

private:
    vec3 _position;
    vec3 _rotation;
    vec3 _scale;
    std::function<void()> _callback = nullptr;

    void notify();
};


#endif //GAUSSIAN_RASTERIZER_TRANSFORM_CUH
