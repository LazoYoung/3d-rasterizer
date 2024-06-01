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

void Scene::add(initializer_list<Geometry*> list) {
    for (auto ptr: list) {
        add(ptr);
    }
}

Shader &Scene::getShader() {
    return shader;
}

Camera &Scene::getCamera() {
    return camera;
}
