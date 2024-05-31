#include "header/Shader.cuh"
#include <fstream>
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
    ShaderUnit unit{type, id};
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

void Shader::useProgram() const {
    glUseProgram(program);
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

GLuint Shader::getProgramId() const {
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
