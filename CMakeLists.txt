cmake_minimum_required(VERSION 3.28)
project(gaussian_rasterizer CUDA)

set(CMAKE_CUDA_STANDARD 17)

add_executable(gaussian_rasterizer
        src/main.cu
)

set_target_properties(gaussian_rasterizer PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
