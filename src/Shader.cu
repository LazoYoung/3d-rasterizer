#include <stdexcept>
#include "header/Shader.cuh"

Shader::Shader() {
    program = glCreateProgram();
}

// todo: is this right place to delete shaders?
Shader::~Shader() {
    for (const ShaderUnit &unit: units) {
        glDeleteShader(unit.id);
    }
}

// todo: support uniform shader
void Shader::add(const char *source, GLenum type) {
    auto id = glCreateShader(type);
    ShaderUnit unit{source, type, id};
    glShaderSource(id, 1, &source, nullptr);
    units.push_back(unit);
}

void Shader::compile() {
    for (const ShaderUnit &unit: units) {
        Shader::compile(unit);
    }
}

void Shader::link() const {
    for (const ShaderUnit &unit: units) {
        glAttachShader(program, unit.id);
    }

    glLinkProgram(program);

    for (const ShaderUnit &unit: units) {
        glDeleteShader(unit.id);
    }
}

void Shader::compile(const ShaderUnit &shader) {
    glCompileShader(shader.id);

    int success;
    glGetShaderiv(shader.id, GL_COMPILE_STATUS, &success);

    if (!success) {
        char infoLog[512];
        string message;

        glGetShaderInfoLog(shader.id, 512, nullptr, infoLog);
        message.append(getShaderName(shader.type))
                .append(" compilation error!\n")
                .append(infoLog);
        throw runtime_error(message);
    }
}

const char *Shader::getShaderName(GLenum type) {
    switch (type) {
        case GL_FRAGMENT_SHADER:
            return "Fragment shader";
        case GL_VERTEX_SHADER:
            return "Vertex shader";
        default:
            return "Unknown shader";
    }
}

GLuint Shader::getProgram() const {
    return program;
}
