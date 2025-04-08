#version 330 core 
out vec4 FragColor;

in vec3 FragPos;

void main() { 
    // 使用位置信息创建变化的颜色
    vec3 color = normalize(abs(FragPos)) * vec3(1.0f, 0.5f, 0.2f);
    FragColor = vec4(color, 1.0f); 
}