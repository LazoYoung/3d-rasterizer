cmake_minimum_required(VERSION 3.28)
project(3d_rasterizer CUDA C)

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
        "${CMAKE_SOURCE_DIR}/lib/*.lib"
)

# Supply source files to produce executable
add_executable(3d_rasterizer ${SOURCE_FILES} ${HEADER_FILES})

set(DEPLOY_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/deploy")
set_property(TARGET 3d_rasterizer PROPERTY CUDA_STANDARD 17)
set_property(TARGET 3d_rasterizer PROPERTY CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET 3d_rasterizer PROPERTY RUNTIME_OUTPUT_DIRECTORY ${DEPLOY_DIRECTORY})

# OpenGL
set_property(TARGET 3d_rasterizer PROPERTY OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL REQUIRED)

# GLFW
add_library(freetype STATIC IMPORTED)
add_library(glfw3 STATIC IMPORTED)
add_library(glfw3_mt STATIC IMPORTED)
add_library(glfw3dll STATIC IMPORTED)
set_target_properties(freetype PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/freetype.lib")
set_target_properties(glfw3 PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/glfw3.lib")
set_target_properties(glfw3_mt PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/glfw3_mt.lib")
set_target_properties(glfw3dll PROPERTIES IMPORTED_LOCATION "${CMAKE_SOURCE_DIR}/lib/glfw3dll.lib")

# GLAD
add_library(glad STATIC "${CMAKE_SOURCE_DIR}/src/glad.c")

# Include directories
target_include_directories(glad PUBLIC "${CMAKE_SOURCE_DIR}/include")
target_include_directories(3d_rasterizer PUBLIC "${CMAKE_SOURCE_DIR}/include")

# Linking
target_link_libraries(3d_rasterizer PUBLIC OpenGL::GL glfw3 glfw3_mt glfw3dll glad freetype)

# Copy DLL
add_custom_command(
        TARGET 3d_rasterizer POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DLL_FILES} $<TARGET_FILE_DIR:3d_rasterizer>
)

# Copy shader and resources
set(RESOURCE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/resources")
set(RESOURCE_DEST_DIR "${DEPLOY_DIRECTORY}")
set(SHADER_SOURCE_DIR "${CMAKE_SOURCE_DIR}/src/shader")
set(SHADER_DEST_DIR "${DEPLOY_DIRECTORY}/shader")
file(MAKE_DIRECTORY ${SHADER_SOURCE_DIR})
file(MAKE_DIRECTORY ${SHADER_DEST_DIR})
add_custom_target(CopyShaders ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Copying fonts..."
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${RESOURCE_SOURCE_DIR} ${RESOURCE_DEST_DIR}
        COMMAND ${CMAKE_COMMAND} -E echo "Copying GLSL files..."
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${SHADER_SOURCE_DIR} ${SHADER_DEST_DIR}
)
add_dependencies(3d_rasterizer CopyShaders)

# Suppress warnings
target_compile_options(3d_rasterizer PUBLIC -w)