#include <stdexcept>
#include "Shader.cuh"

// todo: vertex and uniform injection

// todo: is this right place to delete shaders?
Shader::~Shader() {
    for (ShaderUnit unit: units) {
        glDeleteShader(unit.id);
    }

    free(program);
}

GLuint Shader::getShaderProgram() {
    if (!program) {
        program = static_cast<GLuint *>(malloc(sizeof(GLuint)));
        *program = glCreateProgram();
    }

    return *program;
}

void Shader::attachShader(const char *source, GLenum type) {
    auto id = glCreateShader(type);
    units.emplace_back(source, id, type);
}

void Shader::compile(GLuint shaderProgram) {
    for (ShaderUnit unit: units) {
        compile(unit);
        glAttachShader(shaderProgram, unit.id);
    }

    glLinkProgram(shaderProgram);

}

void Shader::link() {

}

void Shader::compile(const ShaderUnit &shader) {
    glShaderSource(shader.id, 1, &shader.source, nullptr);
    glCompileShader(shader.id);

    int success;
    glGetShaderiv(shader.id, GL_COMPILE_STATUS, &success);

    if (!success) {
        char infoLog[512];
        string message;

        glGetShaderInfoLog(shader.id, 512, nullptr, infoLog);
        message.append(getShaderName(shader.type))
                .append(" compilation error: ")
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

