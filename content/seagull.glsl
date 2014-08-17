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

uniform vec3 ambientColor;
uniform sampler2D diffuseTex;
uniform vec3 camPos;

void main(void)
{
	float specAmount = 1.0f;

	vec3 normal = normalize(Normal);
	vec3 camView = normalize(camPos - WorldPos);
	float diffuse = clamp(normal.x, 0.0f, 1.0f);
	vec3 h = normalize(vec3(1.0f, 0.0f, 0.0f) + camView);
	float spec = max(pow(dot(h, normal), specAmount), 0.0f);

	float light = dot(normalize(Normal), normalize(vec3(-0.5,0.5,-0.5)));
	FragColor = vec4(texture(diffuseTex, Tex).xyz * light, 1.0);
}
