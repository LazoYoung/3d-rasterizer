#ifndef GAUSSIAN_RASTERIZER_SCENE_CUH
#define GAUSSIAN_RASTERIZER_SCENE_CUH


#include "../geometry/Geometry.cuh"
#include "Camera.cuh"

class Geometry;

class Scene {
public:
    explicit Scene(const Shader &shader);

    void draw();

    void add(Geometry *geometry);

    Shader &getShader();

    Camera &getCamera();

private:
    Shader shader;
    Camera camera;
    vector<Geometry*> geometries;
};


#endif //GAUSSIAN_RASTERIZER_SCENE_CUH
