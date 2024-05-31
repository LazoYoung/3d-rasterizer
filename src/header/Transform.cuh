#ifndef GAUSSIAN_RASTERIZER_TRANSFORM_CUH
#define GAUSSIAN_RASTERIZER_TRANSFORM_CUH

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

using namespace glm;

class Transform {
public:
    Transform();

    mat4 getMatrix();

    vec3 getPosition();

    vec3 getRotation();

    vec3 getScale();

    void move(float x, float y, float z);

    void rotate(float x, float y, float z);

    void scale(float x, float y, float z);

    bool shouldUpdate() const;

    void markUpdate();

private:
    vec3 _position;
    vec3 _rotation;
    vec3 _scale;
    bool _update;
};


#endif //GAUSSIAN_RASTERIZER_TRANSFORM_CUH
