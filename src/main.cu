#define GLFW_DLL
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>

using namespace std;

void onWindowResize(GLFWwindow *window, int width, int height);
void processInput(GLFWwindow *window);
void drawBackground();

int main() {
    int windowWidth = 800;
    int windowHeight = 600;

    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    auto *window = glfwCreateWindow(windowWidth, windowHeight, "Gaussian Rasterizer", nullptr, nullptr);

    if (window == nullptr) {
        cout << "Failed to create GLFW window" << endl;
        glfwTerminate();
        return EXIT_FAILURE;
    }

    glfwMakeContextCurrent(window);

    if (!gladLoadGLLoader((GLADloadproc) glfwGetProcAddress)) {
        cout << "Failed to load GLAD" << endl;
        glfwTerminate();
        return EXIT_FAILURE;
    }

    glViewport(0, 0, windowWidth, windowHeight);
    glfwSetFramebufferSizeCallback(window, onWindowResize);

    while (!glfwWindowShouldClose(window)) {
        processInput(window);
        drawBackground();

        // The front buffer represents the image being displayed
        // while all the rendering commands draw to the back buffer.
        glfwSwapBuffers(window);

        // Check if any events are triggered and update the window as necessary
        glfwPollEvents();
    }

    glfwTerminate();
    return 0;
}

void drawBackground() {
    glClearColor(0.2f, 0.2f, 0.2f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}

void onWindowResize(GLFWwindow *window, int width, int height) {
    glViewport(0, 0, width, height);
}

void processInput(GLFWwindow *window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}
