#include "header/Shader.cuh"
#include <stdexcept>
#include <fstream>
#include <iostream>
#include <sstream>

Shader::Shader() {
    program = glCreateProgram();
}

// todo: is this right place to delete shaders?
Shader::~Shader() {
    for (const ShaderUnit &unit: units) {
        glDeleteShader(unit.id);
    }
}

void Shader::add(const char *path, GLenum type) {
    auto id = glCreateShader(type);
    string source_str = getSource(path);
    auto source = source_str.c_str();
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

void Shader::use() const {
    glUseProgram(program);
}

template<typename T>
void Shader::setUniform(const string &name, T value) const {
    auto _name = name.c_str();

    if constexpr (is_same_v<T, int>) {
        glUniform1i(glGetUniformLocation(program, _name), static_cast<GLint>(value));
    } else if constexpr (is_same_v<T, bool>) {
        glUniform1i(glGetUniformLocation(program, _name), static_cast<GLint>(value));
    } else if constexpr (is_same_v<T, float>){
        glUniform1f(glGetUniformLocation(program, _name), static_cast<GLfloat>(value));
    } else {
        throw invalid_argument("Unsupported uniform type!");
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

GLuint Shader::getProgramID() const {
    return program;
}

string Shader::getSource(const char *path) {
    string src;

    try {
        ifstream file;
        stringstream stream;

        file.exceptions(fstream::failbit | fstream::badbit);
        file.open(path);
        stream << file.rdbuf();
        file.close();
        src = stream.str();
    } catch (fstream::failure &failure) {
        cout << failure.what() << endl;
        cout << "Failed to read: " << path << endl;
    }

    return src;
}
