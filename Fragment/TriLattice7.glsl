#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 uv2tri(vec2 uv)
{
    float sx = uv.x - uv.y / 2; // skewed x
    float offs = step(fract(1 - uv.y), fract(sx));
    return vec2(floor(sx) * 2 + offs, floor(uv.y));
}

void main(void)
{
    float res = resolution.y / (5 + sin(time * 0.5));

    vec2 uv = (gl_FragCoord.xy - resolution / 2) / res;
    uv += vec2(1, 0.5) * time;

    vec3 p = vec3(dot(uv, vec2(1, 0.5)), dot(uv, vec2(-1, 0.5)), uv.y);
    vec3 p1 = fract(+p);
    vec3 p2 = fract(-p);

    float d1 = min(min(p1.x, p1.y), p1.z);
    float d2 = min(min(p2.x, p2.y), p2.z);
    float d = min(d1, d2);
    float c1 = (d - 0.04) * res;

    float r = rand(uv2tri(uv)) * 6.3;
    d = dot(uv, vec2(cos(r), sin(r))) + time * 0.25;
    float c2 = (abs(0.5 - fract(d * 4)) - 0.18) * res / 4;

    float c = min(c1, c2);
    fragColor = vec4(c, c, c, 1);
}
