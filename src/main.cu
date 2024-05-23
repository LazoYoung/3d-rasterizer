#include "Window.cuh"
#include "Shader.cuh"

int main() {
    Window window(800, 600, "Gaussian Rasterizer");
    Shader shader;
    float vertices[] = {
            -0.5f, -0.5f, 0.0f,
            0.5f, -0.5f, 0.0f,
            0.0f, 0.5f, 0.0f
    };
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
        shader.add(vertexSource, GL_VERTEX_SHADER);
        shader.add(fragmentSource, GL_FRAGMENT_SHADER);

        // vertex input
        GLuint VBO;
        glGenBuffers(1, &VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof vertices, vertices, GL_STATIC_DRAW);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), nullptr);

        shader.compile();
        shader.link();
        window.enterRenderingLoop();
    } else {
        return EXIT_FAILURE;
    }

    return 0;
}
