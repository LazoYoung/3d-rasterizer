cmake_minimum_required(VERSION 3.28)
project(gaussian_rasterizer CUDA C)

file(GLOB_RECURSE SOURCE_FILES
        "${CMAKE_SOURCE_DIR}/src/*.cpp"
        "${CMAKE_SOURCE_DIR}/src/*.cu"
)

file(GLOB_RECURSE HEADER_FILES
        "${CMAKE_SOURCE_DIR}/src/*.h"
        "${CMAKE_SOURCE_DIR}/src/*.cuh"
)

file(GLOB_RECURSE DLL_FILES
        "${CMAKE_SOURCE_DIR}/lib/*.dll"
)

# Supply source files to produce executable
add_executable(gaussian_rasterizer ${SOURCE_FILES} ${HEADER_FILES})

set(DEPLOY_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/deploy")
set_property(TARGET gaussian_rasterizer PROPERTY CUDA_STANDARD 17)
set_property(TARGET gaussian_rasterizer PROPERTY CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET gaussian_rasterizer PROPERTY RUNTIME_OUTPUT_DIRECTORY ${DEPLOY_DIRECTORY})

# OpenGL
set_property(TARGET gaussian_rasterizer PROPERTY OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL REQUIRED)

# GLFW
add_library(glfw3 STATIC IMPORTED)
add_library(glfw3_mt STATIC IMPORTED)
add_library(glfw3dll STATIC IMPORTED)
set_target_properties(glfw3 PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/glfw3.lib")
set_target_properties(glfw3_mt PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/glfw3_mt.lib")
set_target_properties(glfw3dll PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/glfw3dll.lib")

# GLAD
add_library(glad STATIC "${CMAKE_SOURCE_DIR}/src/glad.c")

# Include directories
target_include_directories(glad PUBLIC "${CMAKE_SOURCE_DIR}/include")
target_include_directories(gaussian_rasterizer PUBLIC "${CMAKE_SOURCE_DIR}/include")

# Linking
target_link_libraries(gaussian_rasterizer PUBLIC OpenGL::GL glfw3 glfw3_mt glfw3dll glad)

# Copy DLL
add_custom_command(
        TARGET gaussian_rasterizer POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DLL_FILES} $<TARGET_FILE_DIR:gaussian_rasterizer>
)

# Copy shader files
set(SHADER_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/shader")
set(SHADER_DEST_DIR "${DEPLOY_DIRECTORY}/shader")
file(MAKE_DIRECTORY ${SHADER_DEST_DIR})
add_custom_target(CopyShaders ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Copying GLSL files..."
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${SHADER_SOURCE_DIR} ${SHADER_DEST_DIR}
)
add_dependencies(gaussian_rasterizer CopyShaders)

# Suppress warnings
target_compile_options(gaussian_rasterizer PUBLIC -w)