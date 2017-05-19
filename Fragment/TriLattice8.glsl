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

    vec3 p = vec3(dot(uv, vec2(1, 0.5)), dot(uv, vec2(-1, 0.5)), uv.y);
    vec3 p1 = fract(+p);
    vec3 p2 = fract(-p);

    // distance from borders
    float d1 = min(min(p1.x, p1.y), p1.z);
    float d2 = min(min(p2.x, p2.y), p2.z);
    float d = min(d1, d2);

    // border line
    float c = clamp((d - 0.04) * res, 0, 1);

    // gradient inside triangles
    float r = rand(uv2tri(uv));
    c *= abs(0.5 - fract(d + r + time * 0.8)) * 2;

    // color variation
    float cb = sin(time * 4.8 + r * 32.984) * 0.5 + 0.5;
    vec3 rgb = mix(vec3(0.75, 0, 0), vec3(1, 0.5, 0.5), cb);

    fragColor = vec4(rgb * c, 1);
}
