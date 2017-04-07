#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

float saturate(float x) { return clamp(x, 0, 1); }
vec3 saturate(vec3 x) { return clamp(x, 0, 1); }

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 palette(float z)
{
    vec3 a = vec3(0.90, 0.60, 0.69);
    vec3 b = vec3(0.17, 0.41, 0.41);
    return saturate(a + b * sin(z * 9 + time * 2));
}

void main(void)
{
    float scale = resolution.y / (6 + sin(time * 0.4) * 3);
    vec2 p = (gl_FragCoord.xy - resolution / 2) / scale;
    vec2 p1 = fract(p) - 0.5;
    vec2 p2 = fract(p - 0.5) - 0.5;

    float z1 = rand(0.19 * floor(p));
    float z2 = rand(0.31 * floor(p - 0.5));

    vec3 c1 = palette(z1);
    vec3 c2 = palette(z2);

    c1 *= saturate((0.25 - abs(0.5 - fract(length(p1) * 10 + 0.26))) * scale / 10);
    c2 *= saturate((0.25 - abs(0.5 - fract(length(p2) * 10 + 0.26))) * scale / 10);

    float a1 = saturate((0.5 - length(p1)) * scale);
    float a2 = saturate((0.5 - length(p2)) * scale);

    vec3 c = mix(
        mix(mix(vec3(0), c1, a1), c2, a2),
        mix(mix(vec3(0), c2, a2), c1, a1),
        step(z1, z2)
    );

    fragColor = vec4(c, 1);
}
