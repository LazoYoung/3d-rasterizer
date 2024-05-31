#include "header/Window.cuh"
#include "header/Triangle.cuh"
#include <iostream>
#include <stdexcept>

using namespace std;

int main() {
    Window window(800, 600, "Gaussian Rasterizer");

    if (!window.init()) {
        cout << "Failed to init window!" << endl;
        return EXIT_FAILURE;
    }

    auto *t1 = new Triangle();
    t1->getTransform().rotate(0.0f, 0.0f, -90.0f);

    try {
        Shader shader;
        shader.add("shader/mesh.vert", GL_VERTEX_SHADER);
        shader.add("shader/mesh.frag", GL_FRAGMENT_SHADER);
        shader.compile();
        shader.link();

        Scene scene(shader);
        scene.add(t1);

        window.startDrawing(scene);
    } catch (std::exception &e) {
        cout << e.what() << endl;
        return EXIT_FAILURE;
    }

    free(t1);

    return 0;
}
