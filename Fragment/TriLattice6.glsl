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
    vec2 uv = (gl_FragCoord.xy - resolution / 2) / resolution.y * 8;

    vec3 p = vec3(dot(uv, vec2(1, 0.5)), dot(uv, vec2(-1, 0.5)), uv.y);
    vec3 p1 = fract(+p);
    vec3 p2 = fract(-p);

    float d1 = min(min(p1.x, p1.y), p1.z);
    float d2 = min(min(p2.x, p2.y), p2.z);
    float d = min(d1, d2);

    vec2 tri = uv2tri(uv);
    float r = rand(tri) * 2 + tri.x / 16 + time * 2;
    float c = step(0.2 + sin(r) * 0.2, d);

    fragColor = vec4(c, c, c, 1);
}
