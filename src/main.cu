#include "header/Window.cuh"
#include <iostream>
#include <stdexcept>

using namespace std;

int main() {
    Window window(800, 600, "Gaussian Rasterizer");

    if (!window.init()) {
        cout << "Failed to init window!" << endl;
        return EXIT_FAILURE;
    }

    try {
        window.startDrawing();
    } catch (std::exception &e) {
        cout << e.what() << endl;
        return EXIT_FAILURE;
    }

    return 0;
}
