#include "Window.cuh"
#include "geometry/Triangle.cuh"
#include "geometry/Rectangle.cuh"
#include "geometry/Cube.cuh"
#include "geometry/PlyLoader.cuh"
#include <iostream>
#include <stdexcept>

using namespace std;

int main() {
    Window window(800, 600, "Gaussian Rasterizer");
    auto *triangle = new Triangle();
    auto *rectangle = new Rectangle();
    auto *cube = new Cube();
    auto &t1 = triangle->getTransform();
    auto &t2 = rectangle->getTransform();
    auto &t3 = cube->getTransform();
    t1.setPosition(-0.5f, 0.5f, 1.0f);
    t1.setRotation(-55.0f, 0.0f, 0.0f);
    t2.setPosition(1.5f, 1.0f, -1.0f);
    t2.setRotation(30.0f, 0.0f, 0.0f);
    t3.setPosition(-1.0f, 0.1f, 1.0f);
    t3.setRotation(30.0f, 30.0f, 0.0f);

    // USER OPTIONS
    Device device = CUDA;
    bool bakeNormals = true;

    try {
        PlyLoader loader(device, bakeNormals);
        Model model = loader.importModel("model/teapot.ply");
        model.getTransform().setScale(0.2f, 0.2f, 0.2f);
        model.getTransform().setRotation(-90.0f, 0.0f, 0.0f);

        Scene scene;
        scene.add(&model);
//        scene.add({triangle, rectangle, cube, &model});

        if (!window.init(&scene)) {
            cout << "Failed to checkBound window!" << endl;
            return EXIT_FAILURE;
        }

        Shader shader(device);
        shader.add("shader/new_mesh.vert", GL_VERTEX_SHADER);
        shader.add("shader/new_mesh.frag", GL_FRAGMENT_SHADER);
        shader.compile();
        shader.link();

        scene.setShader(&shader);
        window.startDrawing();
    } catch (std::exception &e) {
        cout << e.what() << endl;
        return EXIT_FAILURE;
    }

    free(triangle);
    free(rectangle);
    free(cube);

    return 0;
}
