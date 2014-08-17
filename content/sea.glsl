#pragma vertex
#version 330

in vec3 inVertex;
in vec3 inNormal;
in vec2 inTex;

out vec3 Normal;
out vec2 Tex;
out vec3 WorldPos;

uniform mat4 world;
uniform mat4 viewProj;

void main(void)
{
	Normal = inNormal;
	Tex = inTex;
	gl_Position = viewProj * world * vec4(inVertex, 1.0);
	WorldPos = mat3(world) * inVertex;
}

#pragma fragment
#version 330

out vec4 FragColor;
in vec3 Normal;
in vec2 Tex;
in vec3 WorldPos;

void main(void)
{
	float light = dot(normalize(Normal), normalize(vec3(-0.5,0.5,-0.5)));
	FragColor = vec4(light, light, light, 1.0);
}
