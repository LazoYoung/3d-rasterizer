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
    Shader();

    ~Shader();

    void add(const char *source, GLenum type);

    void compile();

    void link() const;

private:
    vector<ShaderUnit> units;
    GLuint program;

    static const char *getShaderName(GLenum type);

    static void compile(const ShaderUnit &shader);

};


#endif //GAUSSIAN_RASTERIZER_SHADER_CUH
