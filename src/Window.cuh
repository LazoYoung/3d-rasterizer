#ifndef GAUSSIAN_RASTERIZER_WINDOW_CUH
#define GAUSSIAN_RASTERIZER_WINDOW_CUH

#define GLFW_DLL

#include "glad/glad.h"
#include "GLFW/glfw3.h"
#include "Text.cuh"
#include "Shader.cuh"
#include "Profiler.cuh"
#include "world/Scene.cuh"

class Text;

class Window {
public:
    Window(int width, int height, const char *title);

    ~Window();

    bool init(Scene *scene);

    ivec2 getDimension() const;

    void setResizeCallback(const function<void(int, int)> &callback);

    void startDrawing();

private:
    int _width;
    int _height;
    const char *_title;
    GLFWwindow *_window;
    Text *_text;
    Profiler _profiler;
    float _lastTime;
    float _deltaTime;
    double _lastMouseX;
    double _lastMouseY;
    bool _pan = false;
    Scene *_scene = nullptr;
    vector<function<void(int, int)>> _resizeCallback;

    void processInput(Camera &camera);

    bool isPressed(int key);

    static void drawBackground();

    void updateTime();

    static void onCursorMove(GLFWwindow *window, double posX, double posY);

    static void setViewport(GLsizei width, GLsizei height);

    static void onResize(GLFWwindow *window, int width, int height);

    void drawMetrics();
};


#endif //GAUSSIAN_RASTERIZER_WINDOW_CUH
