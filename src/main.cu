#include "header/Window.cuh"
#include "header/Shader.cuh"
#include <iostream>
#include <stdexcept>

const char *vertexSource = R"(
#version 330 core
layout (location = 0) in vec3 aPos;

void main() {
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
)";
const char *fragmentSource = R"(
#version 330 core
out vec4 fragColor;

void main() {
    fragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
)";

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
