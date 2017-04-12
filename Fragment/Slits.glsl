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
    float scale = resolution.y / (2 + rand(vec2(floor(time))) * 10);
    vec2 p0 = gl_FragCoord.xy / scale;
    vec2 p1 = floor(p0);
    vec2 p2 = fract(p0);

    float t = time * 1.4;
    float r = rand(p1 + floor(t * 1.333) * 0.11356);

    float x = fract(r * 32.56) < 0.5 ?  p2.x : p2.y;
    x = fract(r * 98.23) < 0.5 ? 1 - x : x;

    float th = smoothstep(0, 1, fract(t - spectrum.x * 2 * r));
    float c = step(th, x);

    fragColor = vec4(c);
}
