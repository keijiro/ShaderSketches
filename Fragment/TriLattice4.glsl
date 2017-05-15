#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

const float PI = 3.14159265359;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 uv2tri(vec2 uv)
{
    float sx = uv.x - uv.y / 2; // skewed x
    float sxf = fract(sx);
    float offs = step(fract(1 - uv.y), sxf);
    return vec2(floor(sx) * 2 + sxf + offs, uv.y);
}

void main(void)
{
    float s = sin(time * 1.2);

    vec2 uv = (gl_FragCoord.xy - resolution / 2) / resolution.y;
    uv.x += uv.y * s * 0.1;
    vec2 p = uv2tri(uv * (8 + s));

    float r1 = rand(floor(p) * 0.011 + 0.345) * PI * 2;
    float r2 = rand(floor(p) * 0.007 + 0.789) * PI * 2;

    p.x += p.y / 2; // unskew

    vec2 dir = vec2(cos(r1), sin(r1));
    float t = dot(p, dir) + r2 + time * 2.94;

    float cr = sin(t * 1.000) * 0.4 + 0.61;
    float cg = sin(t * 0.782) * 0.2 + 0.22;
    float cb = sin(t * 0.751) * 0.3 + 0.32;

    fragColor = vec4(cr, cg, cb, 1);
}
