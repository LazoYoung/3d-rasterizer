#include "Profiler.cuh"

int Profiler::getFramesPerSecond() const {
    return _fps;
}

void Profiler::updateFrameRate() {
    auto now = high_resolution_clock::now();
    auto diff = duration_cast<milliseconds>(now - _lastTime).count();
    _timer += diff;
    _lastTime = now;

    if (_timer > _delay) {
        _fps = diff > 0 ? static_cast<int>(floor(1000.0f / diff)) : 0;
        _timer = 0;
    }
}
