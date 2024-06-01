#include "Window.cuh"
#include "geometry/Triangle.cuh"
#include "geometry/Rectangle.cuh"
#include <iostream>
#include <stdexcept>

using namespace std;

int main() {
    Window window(800, 600, "Gaussian Rasterizer");

    if (!window.init()) {
        cout << "Failed to checkBound window!" << endl;
        return EXIT_FAILURE;
    }

    auto *triangle1 = new Triangle();
    auto &t1 = triangle1->getTransform();
    t1.move(0.1f, 0.0f, 0.0f);
    t1.rotate(-55.0f, 0.0f, 0.0f);

    auto *rectangle = new Rectangle();
    auto &t2 = rectangle->getTransform();
    t2.move(-0.3f, 0.0f, 0.0f);
    t2.rotate(30.0f, 0.0f, 0.0f);

    auto *triangle2 = new Triangle();
    auto &t3 = triangle2->getTransform();
    t3.move(0.3f, 0.0f, 0.0f);

    try {
        Shader shader;
        shader.add("shader/mesh.vert", GL_VERTEX_SHADER);
        shader.add("shader/mesh.frag", GL_FRAGMENT_SHADER);
        shader.compile();
        shader.link();

        Scene scene(shader);
        scene.add(triangle1);
        scene.add(triangle2);
        scene.add(rectangle);

        window.startDrawing(scene);
    } catch (std::exception &e) {
        cout << e.what() << endl;
        return EXIT_FAILURE;
    }

    free(triangle1);
    free(rectangle);
    free(triangle2);

    return 0;
}
