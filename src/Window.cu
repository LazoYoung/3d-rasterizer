#include <iostream>
#include "Window.cuh"

using namespace std;

Window::Window(int width, int height, const char *title)
        : width(width), height(height), title(title), window(nullptr) {}

Window::~Window() {
    glfwTerminate();
}

bool Window::init() {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    window = glfwCreateWindow(width, height, "Gaussian Rasterizer", nullptr, nullptr);

    if (window == nullptr) {
        cout << "Failed to create GLFW window" << endl;
        glfwTerminate();
        return false;
    }

    glfwMakeContextCurrent(window);

    if (!gladLoadGLLoader((GLADloadproc) glfwGetProcAddress)) {
        cout << "Failed to load GLAD" << endl;
        glfwTerminate();
        return false;
    }

    glViewport(0, 0, width, height);
    glfwSetFramebufferSizeCallback(window, onWindowResize);
    return true;
}

void Window::enterRenderingLoop() {
    while (!glfwWindowShouldClose(window)) {
        processInput();
        drawBackground();

        // The front buffer represents the image being displayed
        // while all the rendering commands draw to the back buffer.
        glfwSwapBuffers(window);

        // Check if any events are triggered and update the window as necessary
        glfwPollEvents();
    }
}

void Window::onWindowResize(GLFWwindow *window, int width, int height) {
    glViewport(0, 0, width, height);
}

void Window::processInput() {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}

void Window::drawBackground() {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
}