cmake_minimum_required(VERSION 3.28)
project(gaussian_rasterizer CUDA)

file(GLOB_RECURSE SOURCE_FILES
        ${CMAKE_SOURCE_DIR}/src/*.cpp
        ${CMAKE_SOURCE_DIR}/src/*.cu
)

file(GLOB_RECURSE HEADER_FILES
        ${CMAKE_SOURCE_DIR}/src/*.h
        ${CMAKE_SOURCE_DIR}/src/*.cuh
)

file(GLOB_RECURSE LIBS
        ${CMAKE_SOURCE_DIR}/lib/*.dll
        ${CMAKE_SOURCE_DIR}/lib/*.lib
)

add_executable(gaussian_rasterizer ${SOURCE_FILES} ${HEADER_FILES})

set_property(TARGET gaussian_rasterizer PROPERTY LINKER_LANGUAGE CXX)
set_property(TARGET gaussian_rasterizer PROPERTY CUDA_STANDARD 17)
set_property(TARGET gaussian_rasterizer PROPERTY CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET gaussian_rasterizer PROPERTY RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/deploy")

# OpenGL
set_property(TARGET gaussian_rasterizer PROPERTY OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL REQUIRED)

# Local libraries
add_library(libs INTERFACE ${LIBS})

# Linking
target_include_directories(gaussian_rasterizer INTERFACE "include/")
target_link_libraries(gaussian_rasterizer PUBLIC libs)
