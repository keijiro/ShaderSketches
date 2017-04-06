#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

float saturate(float x) { return clamp(x, 0, 1); }

float rand(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 palette(float z) {
    return vec3(
        1,
        0.6 + 0.4 * sin(z * 8 + time * 2),
        0.5 + 0.4 * sin(z * 5 + time * 3)
    );
}

void main(void)
{
    float scale = resolution.y / (6 + sin(time * 0.4) * 5);
    vec2 p = (gl_FragCoord.xy - resolution / 2) / scale;
    vec2 p1 = fract(p) - 0.5;
    vec2 p2 = fract(p - 0.5) - 0.5;

    float z1 = rand(0.19 * floor(p));
    float z2 = rand(0.31 * floor(p - 0.5));

    float d1 = saturate((0.25 - abs(0.5 - fract(length(p1) * 10 + 0.255))) * scale / 10);
    float d2 = saturate((0.25 - abs(0.5 - fract(length(p2) * 10 + 0.255))) * scale / 10);

    float a1 = saturate((0.5 - length(p1)) * scale);
    float a2 = saturate((0.5 - length(p2)) * scale);

    vec3 c1 = palette(z1);
    vec3 c2 = palette(z2);

    vec3 c = mix(
        mix(mix(vec3(0), c1 * d1, a1), c2 * d2, a2),
        mix(mix(vec3(0), c2 * d2, a2), c1 * d1, a1),
        step(z1, z2)
    );

    fragColor = vec4(c, 1);
}
