#ifndef INC_3D_RASTERIZER_PROFILER_CUH
#define INC_3D_RASTERIZER_PROFILER_CUH


#include <chrono>
#include <type_traits>

using namespace std::chrono;

enum ChronoState {
    RUN, STOP
};

class Profiler {
public:
    void updateFrameRate();

    int getFramesPerSecond() const;

    void startChrono();

    void stopChrono();

    long long getElapsed();

private:
    int _fps = 0;
    const int _delay = 200L;
    long long _timer = 0L;
    high_resolution_clock::time_point _lastFrame;
    high_resolution_clock::time_point _startPoint;
    high_resolution_clock::time_point _stopPoint;
    ChronoState _state = STOP;
};


#endif //INC_3D_RASTERIZER_PROFILER_CUH
