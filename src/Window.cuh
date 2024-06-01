#ifndef GAUSSIAN_RASTERIZER_WINDOW_CUH
#define GAUSSIAN_RASTERIZER_WINDOW_CUH

#define GLFW_DLL

#include "glad/glad.h"
#include "GLFW/glfw3.h"
#include "Shader.cuh"
#include "Profiler.cuh"
#include "world/Scene.cuh"


class Window {
public:
    Window(int width, int height, const char *title);

    ~Window();

    bool init(Scene *scene);

    void startDrawing();

private:
    int _width;
    int _height;
    const char *_title;
    GLFWwindow *_window;
    Profiler _profiler;
    float _lastTime;
    float _deltaTime;
    double _lastMouseX;
    double _lastMouseY;
    bool _pan = false;
    Scene *_scene = nullptr;

    void processInput(Camera &camera);

    bool isPressed(int key);

    static void drawBackground();

    void updateTime();

    static void onCursorMove(GLFWwindow *window, double posX, double posY);

    static void setViewport(GLsizei width, GLsizei height);
};


#endif //GAUSSIAN_RASTERIZER_WINDOW_CUH
