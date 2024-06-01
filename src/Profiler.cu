#include "Profiler.cuh"

float Profiler::getFramesPerSecond() const {
    return _fps;
}

void Profiler::updateFrameRate() {
    auto now = high_resolution_clock::now();
    float diff = static_cast<float>(duration_cast<milliseconds>(now - _lastTime).count());
    _fps = diff > 0.0f ? 1000.0f / diff : 0.0f;
    _lastTime = now;
}
