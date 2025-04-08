#version 330 core 
layout (location = 0) in vec3 aPos; 

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 FragPos;

void main() { 
    // 计算最终位置
    gl_Position = projection * view * model * vec4(aPos, 1.0);
    
    // 传递世界空间坐标给片段着色器
    FragPos = vec3(model * vec4(aPos, 1.0));
}
