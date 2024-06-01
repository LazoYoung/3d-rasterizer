#include "Scene.cuh"

Scene::Scene(const Shader &shader) : shader(shader) {}

void Scene::draw() {
    shader.useProgram();

    for (auto *geometry: geometries) {
        geometry->render(this);
    }
}

void Scene::add(Geometry *geometry) {
    geometries.push_back(geometry);
}

Shader &Scene::getShader() {
    return shader;
}

Camera &Scene::getCamera() {
    return camera;
}
