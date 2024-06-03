#include "Profiler.cuh"

int Profiler::getFramesPerSecond() const {
    return _fps;
}

void Profiler::updateFrameRate() {
    auto thisFrame = high_resolution_clock::now();
    auto diff = duration_cast<milliseconds>(thisFrame - _lastFrame).count();
    _timer += diff;
    _lastFrame = thisFrame;

    if (_timer > _delay) {
        _fps = diff > 0 ? static_cast<int>(floor(1000.0f / diff)) : 0;
        _timer = 0;
    }
}

void Profiler::startChrono() {
    _state = RUN;
    _startPoint = high_resolution_clock::now();
}

void Profiler::stopChrono() {
    _state = STOP;
    _stopPoint = high_resolution_clock::now();
}

long long Profiler::getElapsed() {
    if (_state == RUN) {
        stopChrono();
    }

    return duration_cast<milliseconds>(_stopPoint - _startPoint).count();
}
