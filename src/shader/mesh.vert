#version 330 core

layout (location = 0) in vec3 position;
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform bool decouple;

void main() {
    if (decouple) {
        gl_Position = vec4(position, 1.0f);
    } else {
        gl_Position = projection * view * model * vec4(position, 1.0f);
    }
}
