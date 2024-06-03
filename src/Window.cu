#include "Window.cuh"
#include <iostream>
#include <sstream>
#include <iomanip>

using namespace std;

Window::Window(int width, int height, const char *title) :
        _width(width), _height(height), _title(title),
        _window(nullptr), _text(nullptr),
        _lastMouseX(-1.0),
        _lastMouseY(-1.0),
        _lastTime(0), _deltaTime(0) {}

Window::~Window() {
    if (_text) {
        free(_text);
    }

    glfwTerminate();
}

bool Window::init(Scene *scene) {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    _window = glfwCreateWindow(_width, _height, "Gaussian Rasterizer", nullptr, nullptr);
    _scene = scene;

    if (_window == nullptr) {
        cout << "Failed to create GLFW window" << endl;
        glfwTerminate();
        return false;
    }

    glfwMakeContextCurrent(_window);

    if (!gladLoadGLLoader((GLADloadproc) glfwGetProcAddress)) {
        cout << "Failed to load GLAD" << endl;
        glfwTerminate();
        return false;
    }

    glEnable(GL_DEPTH_TEST);
    glfwSetWindowUserPointer(_window, this);
    glfwSetCursorPosCallback(_window, Window::onCursorMove);
    Window::setViewport(_width, _height);
    glfwSetFramebufferSizeCallback(_window, Window::onResize);

    _text = new Text();
    _text->init("font/arial.ttf", this);

    return true;
}

ivec2 Window::getDimension() const {
    return {_width, _height};
}

void Window::setViewport(GLsizei width, GLsizei height) {
    glViewport(0, 0, width, height);
}

void Window::onResize(GLFWwindow *window, int width, int height) {
    auto *self = static_cast<Window *>(glfwGetWindowUserPointer(window));

    for (auto &callback: self->_resizeCallback) {
        callback(width, height);
    }

    Window::setViewport(width, height);
}

void Window::setResizeCallback(const function<void(int, int)> &callback) {
    _resizeCallback.push_back(callback);
}

void Window::startDrawing() {
    while (!glfwWindowShouldClose(_window)) {
        updateTime();

        // Process user input
        processInput(_scene->getCamera());

        // Draw pixels
        drawBackground();
        drawText();
        _scene->draw();

        // The front buffer represents the image being displayed
        // while all the rendering commands draw to the back buffer.
        glfwSwapBuffers(_window);

        // Check if any events are triggered and update the window as necessary
        glfwPollEvents();

        // Update profiler every frame
        _profiler.updateFrameRate();
    }
}

void Window::onCursorMove(GLFWwindow *window, double posX, double posY) {
    auto self = static_cast<Window *>(glfwGetWindowUserPointer(window));

    if (!self->_pan) {
        self->_lastMouseX = -1.0;
        self->_lastMouseY = -1.0;
        return;
    }

    double lastX = self->_lastMouseX;
    double lastY = self->_lastMouseY;
    double offsetX = lastX < 0.0 ? 0.0 : posX - lastX;
    double offsetY = lastY < 0.0 ? 0.0 : self->_lastMouseY - posY;
    self->_lastMouseX = posX;
    self->_lastMouseY = posY;

    static float sensitivity = 0.1f;
    offsetX *= sensitivity;
    offsetY *= sensitivity;

    auto &camera = self->_scene->getCamera();
    camera.yaw(offsetX);
    camera.pitch(offsetY);
}

void Window::processInput(Camera &camera) {
    if (glfwGetKey(_window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(_window, true);
    }

    auto &up = camera.getUpAxis();
    auto forward = camera.getForwardAxis();
    auto &right = camera.getRightAxis();
    float speed = _deltaTime * camera.getSpeed();

    if (isPressed(GLFW_KEY_W)) {
        camera.move(speed * forward);
    } else if (isPressed(GLFW_KEY_A)) {
        camera.move(speed * right);
    } else if (isPressed(GLFW_KEY_S)) {
        camera.move(-1 * speed * forward);
    } else if (isPressed(GLFW_KEY_D)) {
        camera.move(-1 * speed * right);
    } else if (isPressed(GLFW_KEY_Q)) {
        camera.move(-1 * speed * up);
    } else if (isPressed(GLFW_KEY_E)) {
        camera.move(speed * up);
    }

    _pan = glfwGetMouseButton(_window, GLFW_MOUSE_BUTTON_RIGHT) == GLFW_PRESS;
}

bool Window::isPressed(int key) {
    return glfwGetKey(_window, key) == GLFW_PRESS;
}

void Window::drawBackground() {
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

void Window::updateTime() {
    auto now = static_cast<float>(glfwGetTime());
    _deltaTime = now - _lastTime;
    _lastTime = now;
}

void Window::drawText() {
    string metrics;
    stringstream stream;

    metrics.append("FPS: ");
    stream << fixed << setprecision(1) << _profiler.getFramesPerSecond();
    metrics.append(stream.str());

    _text->render(metrics, 18, vec3(1.0f, 1.0f, 1.0f), vec2(20.0f, 20.0f));

    string credit("Multicore Programming Final Project");
    _text->render(credit, 14, vec3(1.0f, 1.0f, 1.0f), vec2(230.0f, 20.0f), topRight);
}
