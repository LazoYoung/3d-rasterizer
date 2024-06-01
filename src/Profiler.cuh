#ifndef INC_3D_RASTERIZER_PROFILER_CUH
#define INC_3D_RASTERIZER_PROFILER_CUH


#include <chrono>

using namespace std::chrono;

class Profiler {
public:
    void updateFrameRate();
    float getFramesPerSecond() const;

private:
    high_resolution_clock::time_point _lastTime;
    float _fps = 0.0f;
};


#endif //INC_3D_RASTERIZER_PROFILER_CUH
