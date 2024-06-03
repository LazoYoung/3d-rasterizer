#ifndef GAUSSIAN_RASTERIZER_SHADER_CUH
#define GAUSSIAN_RASTERIZER_SHADER_CUH


#define GLFW_DLL

#include "glad/glad.h"
#include "GLFW/glfw3.h"
#include "glm/glm.hpp"
#include "glm/gtc/type_ptr.hpp"
#include "Device.cuh"
#include <vector>
#include <string>
#include <stdexcept>
#include <functional>
#include <iostream>
#include <type_traits>

using namespace std;

struct ShaderUnit {
    GLenum type;
    GLuint id;
};

class Shader {
public:
    explicit Shader(Device device);

    ~Shader();

    void add(const char *path, GLenum type);

    void compile();

    void link() const;

    void useProgram() const;

    GLuint getProgramId() const;

    Device getDevice();

    void setDevice(Device device);

    template<typename... T>
    void setUniform(const string &name, T... value) const {
        GLint location = glGetUniformLocation(_programId, name.c_str());
        function < void(GLint, T...) > glFunc;
        constexpr int count = sizeof...(T);

        if constexpr ((is_same_v<int, T> || ...) || ((is_same_v<bool, T> || ...))) {
            if constexpr (count == 1) {
                glFunc = glUniform1i;
            } else if constexpr (count == 2) {
                glFunc = glUniform2i;
            } else if constexpr (count == 3) {
                glFunc = glUniform3i;
            } else if constexpr (count == 4) {
                glFunc = glUniform4i;
            } else {
                throw invalid_argument("Too few or many arguments!");
            }
        } else if constexpr ((is_same_v<float, T> || ...)) {
            if constexpr (count == 1) {
                glFunc = glUniform1f;
            } else if constexpr (count == 2) {
                glFunc = glUniform2f;
            } else if constexpr (count == 3) {
                glFunc = glUniform3f;
            } else if constexpr (count == 4) {
                glFunc = glUniform4f;
            } else {
                throw invalid_argument("Too few or many arguments!");
            }
        } else {
            throw invalid_argument("Unsupported uniform type!");
        }

        glFunc(location, value...);
    }

    template<typename T>
    void setUniformMatrix(const function<void(GLint, GLsizei, GLboolean, const GLfloat*)> &glFunc, const string &name, bool transpose, T matrix) const {
        // todo: location can be cached
        auto location = glGetUniformLocation(_programId, name.c_str());
        auto ptr = glm::value_ptr(matrix);

        glFunc(location, 1, transpose, ptr);
    }

private:
    vector<ShaderUnit> _units;
    GLuint _programId;
    Device _device;

    static const char *getShaderName(GLenum type);

    static void compile(const ShaderUnit &shader);

    static string getSource(const char *path);
};


#endif //GAUSSIAN_RASTERIZER_SHADER_CUH
