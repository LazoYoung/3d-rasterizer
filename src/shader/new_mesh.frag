#version 330 core

uniform vec3 color;
uniform vec3 lightColor;
uniform vec3 lightPos;
in vec3 fragPos;
in vec3 fragNormal;
out vec4 fragColor;

void main() {
    float ambientStrength = 0.1f;
    vec3 ambient = ambientStrength * lightColor;
    vec3 norm = normalize(fragNormal);
    vec3 lightDir = normalize(lightPos - fragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * lightColor;
    vec3 result = (ambient + diffuse) * color;
    fragColor = vec4(result, 1.0);
}
