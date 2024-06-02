#ifndef INC_3D_RASTERIZER_PROFILER_CUH
#define INC_3D_RASTERIZER_PROFILER_CUH


#include <chrono>

using namespace std::chrono;

class Profiler {
public:
    void updateFrameRate();
    int getFramesPerSecond() const;

private:
    const int _delay = 200L;
    high_resolution_clock::time_point _lastTime;
    int _fps = 0;
    long long _timer = 0L;
};


#endif //INC_3D_RASTERIZER_PROFILER_CUH
