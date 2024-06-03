#ifndef GAUSSIAN_RASTERIZER_SCENE_CUH
#define GAUSSIAN_RASTERIZER_SCENE_CUH


#include "../geometry/Geometry.cuh"
#include "Camera.cuh"

class Geometry;

class Scene {
public:
    void draw();

    void add(Geometry *geometry);

    void add(initializer_list<Geometry *> list);

    Camera &getCamera();

    Shader *getShader();

    void setShader(Shader *shader);

    void setLightPosition(fvec3 pos);

private:
    Camera _camera;
    vector<Geometry *> _geometries;
    Shader *_shader = nullptr;
    fvec3 _lightPos = vec3(1.0f, 3.0f, 1.0f);
    fvec3 _lightColor = vec3(1.0f, 1.0f, 1.0f);

    void updateLight();
};


#endif //GAUSSIAN_RASTERIZER_SCENE_CUH
