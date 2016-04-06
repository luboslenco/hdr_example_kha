#version 450

#ifdef GL_ES
precision mediump float;
#endif

uniform float exposure;
uniform sampler2D tex;
in vec2 texCoord;
in vec4 color;

const float gamma = 2.2;

void main() {
	vec3 hdrColor = texture(tex, texCoord).rgb;
	vec3 result = vec3(1.0) - exp(-hdrColor * exposure);
	result = pow(result, vec3(1.0 / gamma));
	gl_FragColor = vec4(result, 1.0);
}
