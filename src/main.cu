#include "Window.cuh"
#include "Shader.cuh"

int main() {
    Window window(800, 600, "Gaussian Rasterizer");
    Shader shader;
    const char *vertexSource = R"(
layout (location = 0) in vec3 aPos;
void main() {
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
)";
    const char *fragmentSource = R"(
out vec4 fragColor;
void main() {
    fragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
)";

    if (window.init()) {
        shader.attachShader(vertexSource, GL_VERTEX_SHADER);
        shader.attachShader(fragmentSource, GL_FRAGMENT_SHADER);
        shader.compile();
        shader.link();
        window.enterRenderingLoop();
    } else {
        return EXIT_FAILURE;
    }

    return 0;
}
