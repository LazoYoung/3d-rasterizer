#ifndef GAUSSIAN_RASTERIZER_WINDOW_CUH
#define GAUSSIAN_RASTERIZER_WINDOW_CUH

#define GLFW_DLL

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include "Shader.cuh"
#include "Scene.cuh"


class Window {
public:
    Window(int width, int height, const char *title);

    ~Window();

    bool init();

    void startDrawing(Scene &scene);

private:
    int width;
    int height;
    const char *title;
    GLFWwindow *window;

    void processInput();

    static void drawBackground();
};


#endif //GAUSSIAN_RASTERIZER_WINDOW_CUH
