#include "Scene.cuh"

Scene::Scene(const Shader &shader) : shader(shader) {}

void Scene::draw() {
    shader.useProgram();

    for (auto *geometry: geometries) {
        geometry->render(shader);
    }
}

void Scene::add(Geometry *geometry) {
    geometries.push_back(geometry);
}
