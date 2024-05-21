#include "Window.cuh"

int main() {
    Window window(800, 600, "Gaussian Rasterizer");

    if (window.init()) {
        window.enterRenderingLoop();
    } else {
        return EXIT_FAILURE;
    }

    return 0;
}
