#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

float saturate(float x) { return clamp(x, 0, 1); }

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void main(void)
{
    float scale = resolution.y / 10;
    vec2 p = gl_FragCoord.xy / scale;
    vec2 p1 = fract(p) - 0.5;
    vec2 p2 = fract(p - 0.5) - 0.5;

    float z1 = rand(0.12 * floor(p));
    float z2 = rand(0.23 * floor(p - 0.5));

    float r1 = 0.2 + 0.2 * sin(time * 1.9 + z1 * 30);
    float r2 = 0.2 + 0.2 * sin(time * 1.9 + z2 * 30);

    float c1 = saturate((r1 - length(p1)) * scale);
    float c2 = saturate((r2 - length(p2)) * scale);

    float a1 = saturate((r1 + 0.08 - length(p1)) * scale);
    float a2 = saturate((r2 + 0.08 - length(p2)) * scale);

    float c = mix(
        mix(mix(0, c1, a1), c2, a2),
        mix(mix(0, c2, a2), c1, a1),
        step(z1, z2)
    );

    fragColor = vec4(c, c, c, 1);
}
