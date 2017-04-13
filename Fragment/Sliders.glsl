#version 150

uniform float time;
uniform vec2 resolution;
uniform vec3 spectrum;
out vec4 fragColor;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void main(void)
{
    float t = time * 1.2;

    float rep = 2 + pow(rand(vec2(floor(t))), 2) * 100;
    vec2 p0 = gl_FragCoord.xy / vec2(20, resolution.y / rep);
    vec2 p1 = floor(p0);
    vec2 p2 = fract(p0);

    float r = rand(p1 + floor(t) * 0.11356);
    float x = 1 - p2.y;
    float sp = mix(spectrum.x * 2, spectrum.y * 4, r > 0.5 ? 1 : 0);
    float th = fract(t - min(1, sp * (1 + r * 2)));
    float c = step(smoothstep(0, 1, th), x);

    fragColor = vec4(c);
}
