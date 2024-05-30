#include "header/Window.cuh"
#include "header/Shader.cuh"
#include <iostream>
#include <stdexcept>

using namespace std;

int main() {
    Window window(800, 600, "Gaussian Rasterizer");

    if (!window.init()) {
        cout << "Failed to init window!" << endl;
        return EXIT_FAILURE;
    }

    try {
        Shader shader;
        shader.add("shader/triangle.vert", GL_VERTEX_SHADER);
        shader.add("shader/triangle.frag", GL_FRAGMENT_SHADER);
        shader.compile();
        shader.link();
        window.startDrawing(shader);
    } catch (std::exception &e) {
        cout << e.what() << endl;
        return EXIT_FAILURE;
    }

    return 0;
}
