#ifndef GAUSSIAN_RASTERIZER_WINDOW_CUH
#define GAUSSIAN_RASTERIZER_WINDOW_CUH

#define GLFW_DLL

#include <glad/glad.h>
#include <GLFW/glfw3.h>


class Window {
public:
    Window(int width, int height, const char *title);

    ~Window();

    bool init();

    void enterRenderingLoop();

private:
    int width;
    int height;
    const char *title;
    GLFWwindow *window;

    static void onWindowResize(GLFWwindow *window, int width, int height);

    void processInput();

    void drawBackground();
};


#endif //GAUSSIAN_RASTERIZER_WINDOW_CUH
