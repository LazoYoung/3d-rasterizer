#ifndef GAUSSIAN_RASTERIZER_SHADER_CUH
#define GAUSSIAN_RASTERIZER_SHADER_CUH

#define GLFW_DLL

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <vector>


using namespace std;

struct ShaderUnit {
    const char *source;
    GLuint id;
    GLenum type;
};

class Shader {
public:
    Shader() = default;

    ~Shader();

    void attachShader(const char *source, GLenum type);

private:
    vector<ShaderUnit> units;
    GLuint *program;
    const char *vertexSource = R"(
layout (location = 0) in vec3 aPos;
void main() {
    gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
)";
    const char *fragmentSource = R"(
out vec4 fragColor;
void main() {
    fragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
)";

    static const char *getShaderName(GLenum type);

    static void compile(const ShaderUnit &shader);

    void link();

    void compile(GLuint shaderProgram);

    GLuint getShaderProgram();
};


#endif //GAUSSIAN_RASTERIZER_SHADER_CUH
