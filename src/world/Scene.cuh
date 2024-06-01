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

private:
    Camera _camera;
    vector<Geometry *> _geometries;
    Shader *_shader = nullptr;
};


#endif //GAUSSIAN_RASTERIZER_SCENE_CUH
