#include <stdexcept>
#include "Shader.cuh"

// todo: vertex and uniform injection

Shader::Shader() {
    program = glCreateProgram();
}

// todo: is this right place to delete shaders?
Shader::~Shader() {
    for (ShaderUnit unit: units) {
        glDeleteShader(unit.id);
    }
}

//GLuint Shader::getShaderProgram() {
//    if (!program) {
//        program = static_cast<GLuint *>(malloc(sizeof(GLuint)));
//        *program = glCreateProgram();
//    }
//
//    return *program;
//}

void Shader::add(const char *source, GLenum type) {
    auto id = glCreateShader(type);
    glShaderSource(id, 1, &source, nullptr);
    units.emplace_back(source, id, type);
}

void Shader::compile() {
    for (ShaderUnit unit: units) {
        compile(unit);
    }
}

void Shader::link() const {
    for (ShaderUnit unit: units) {
        glAttachShader(program, unit.id);
    }

    glLinkProgram(program);

    for (ShaderUnit unit: units) {
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
