#include "Window.cuh"
#include "geometry/Triangle.cuh"
#include "geometry/Rectangle.cuh"
#include "geometry/Cube.cuh"
#include <iostream>
#include <stdexcept>

using namespace std;

int main() {
    Window window(800, 600, "Gaussian Rasterizer");

    if (!window.init()) {
        cout << "Failed to checkBound window!" << endl;
        return EXIT_FAILURE;
    }

    auto *triangle = new Triangle();
    auto &t1 = triangle->getTransform();
    t1.move(0.2f, 0.0f, 0.0f);
    t1.rotate(-55.0f, 0.0f, 0.0f);

    auto *rectangle = new Rectangle();
    auto &t2 = rectangle->getTransform();
    t2.move(0.1f, 0.0f, -1.0f);
    t2.rotate(30.0f, 0.0f, 0.0f);

    auto *cube = new Cube();
    auto &t3 = cube->getTransform();
    t3.move(-0.2f, 0.1f, 0.0f);
    t3.rotate(30.0f, 30.0f, 0.0f);

    try {
        Shader shader;
        shader.add("shader/mesh.vert", GL_VERTEX_SHADER);
        shader.add("shader/mesh.frag", GL_FRAGMENT_SHADER);
        shader.compile();
        shader.link();

        Scene scene(shader);
        scene.add({triangle, rectangle, cube});

        window.startDrawing(scene);
    } catch (std::exception &e) {
        cout << e.what() << endl;
        return EXIT_FAILURE;
    }

    free(triangle);
    free(rectangle);
    free(cube);

    return 0;
}
