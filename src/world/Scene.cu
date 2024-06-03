#include "Scene.cuh"

void Scene::draw() {
    if (!_shader) {
        throw runtime_error("Shader is null!");
    }

    _shader->useProgram();

    updateLight();

    for (auto *geometry: _geometries) {
        geometry->render(this);
    }
}

void Scene::add(Geometry *geometry) {
    _geometries.push_back(geometry);
}

void Scene::add(initializer_list<Geometry *> list) {
    for (auto ptr: list) {
        add(ptr);
    }
}

Shader *Scene::getShader() {
    return _shader;
}

Camera &Scene::getCamera() {
    return _camera;
}

void Scene::setShader(Shader *shader) {
    _shader = shader;
}

void Scene::updateLight() {
    _shader->useProgram();
    _shader->setUniform("lightPos", _lightPos.x, _lightPos.y, _lightPos.z);
    _shader->setUniform("lightColor", _lightColor.x, _lightColor.y, _lightColor.z);
}

void Scene::setLightPosition(fvec3 pos) {
    _lightPos = pos;
}
