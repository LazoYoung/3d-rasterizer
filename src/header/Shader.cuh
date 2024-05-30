#ifndef GAUSSIAN_RASTERIZER_SHADER_CUH
#define GAUSSIAN_RASTERIZER_SHADER_CUH

#define GLFW_DLL

#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <vector>
#include <string>


using namespace std;

struct ShaderUnit {
    const char *source;
    GLenum type;
    GLuint id;
};

class Shader {
public:
    Shader();

    ~Shader();

    void add(const char *path, GLenum type);

    GLuint getProgramID() const;

    template <typename T>
    void setUniform(const string &name, T value) const;

    void compile();

    void link() const;

    void use() const;

private:
    vector<ShaderUnit> units;
    GLuint program;

    static const char *getShaderName(GLenum type);

    static void compile(const ShaderUnit &shader);

    static string getSource(const char *path);
};


#endif //GAUSSIAN_RASTERIZER_SHADER_CUH
