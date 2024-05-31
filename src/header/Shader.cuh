#ifndef GAUSSIAN_RASTERIZER_SHADER_CUH
#define GAUSSIAN_RASTERIZER_SHADER_CUH


#define GLFW_DLL

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <vector>
#include <string>
#include <stdexcept>
#include <functional>
#include <iostream>

using namespace std;

struct ShaderUnit {
    GLenum type;
    GLuint id;
};

class Shader {
public:
    Shader();

    ~Shader();

    void add(const char *path, GLenum type);

    GLuint getProgramId() const;

    void compile();

    void link() const;

    void useProgram() const;

    template<typename... T>
    void setUniform(const string &name, T... value) const {
        GLint location = glGetUniformLocation(program, name.c_str());
        function < void(GLint, T...) > set;
        constexpr int count = sizeof...(T);

        if constexpr ((is_same_v<GLint, T> || ...) || ((is_same_v<GLboolean, T> || ...))) {
            if constexpr (count == 1) {
                set = glUniform1i;
            } else if constexpr (count == 2) {
                set = glUniform2i;
            } else if constexpr (count == 3) {
                set = glUniform3i;
            } else if constexpr (count == 4) {
                set = glUniform4i;
            } else {
                throw invalid_argument("Too few or many arguments!");
            }
        } else if constexpr ((is_same_v<GLfloat, T> || ...)) {
            if constexpr (count == 1) {
                set = glUniform1f;
            } else if constexpr (count == 2) {
                set = glUniform2f;
            } else if constexpr (count == 3) {
                set = glUniform3f;
            } else if constexpr (count == 4) {
                set = glUniform4f;
            } else {
                throw invalid_argument("Too few or many arguments!");
            }
        } else {
            throw invalid_argument("Unsupported uniform type!");
        }

        set(location, value...);
    }

private:
    vector<ShaderUnit> units;
    GLuint program;

    static const char *getShaderName(GLenum type);

    static void compile(const ShaderUnit &shader);

    static string getSource(const char *path);
};


#endif //GAUSSIAN_RASTERIZER_SHADER_CUH
