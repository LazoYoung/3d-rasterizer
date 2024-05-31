#include "header/Scene.cuh"

Scene::Scene(const Shader &shader) : shader(shader) {}

void Scene::draw() {
    for (auto &geometry: geometries) {
        geometry.draw();
    }
}

Geometry &Scene::addGeometry() {
    return geometries.emplace_back(shader);
}
