#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

float saturate(float x) { return clamp(x, 0, 1); }

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 palette(float z)
{
    float g = 0.6 + 0.4 * sin(z * 8 + time * 2);
    float b = 0.5 + 0.4 * sin(z * 5 + time * 3);
    return vec3(1, g, b);
}

void main(void)
{
    float scale = resolution.y / 5;
    vec2 p = gl_FragCoord.xy / scale;

    vec2 offs1 = vec2(time * 0.53, sin(time * 1.35) * 0.2);
    vec2 offs2 = vec2(time * 0.81, sin(time * 1.19) * 0.2);

    vec2 p1 = p + offs1;
    vec2 p2 = p + offs2 - 0.5;

    float z1 = rand(0.19 * floor(p1));
    float z2 = rand(0.31 * floor(p2));

    p1 = fract(p1) - 0.5;
    p2 = fract(p2) - 0.5;

    float s1 = 0.9 + sin(time * (0.6 + z1)) * 0.6;
    float s2 = 0.9 + sin(time * (0.6 + z2)) * 0.6;

    float d1 = (0.25 - abs(0.5 - fract(length(p1) * s1 * 10 + 0.26))) / (s1 * 10);
    float d2 = (0.25 - abs(0.5 - fract(length(p2) * s2 * 10 + 0.26))) / (s2 * 10);

    vec3 c1 = palette(z1) * saturate(d1 * scale);
    vec3 c2 = palette(z2) * saturate(d2 * scale);

    float a1 = saturate((0.5 - length(p1)) * scale);
    float a2 = saturate((0.5 - length(p2)) * scale);

    vec3 c1on2 = mix(c2 * a2, c1, a1);
    vec3 c2on1 = mix(c1 * a1, c2, a2);

    fragColor = vec4(mix(c2on1, c1on2, step(z1, z2)), 1);
}
