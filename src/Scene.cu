#include "header/Scene.cuh"

Scene::Scene(const Shader &shader) : shader(shader) {}

void Scene::draw() {
    for (auto *geometry: geometries) {
        geometry->draw(shader);
    }
}

void Scene::add(Geometry *geometry) {
    geometries.push_back(geometry);
}
