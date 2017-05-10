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
    float sxf = fract(sx);
    float offs = step(fract(1 - uv.y), sxf);
    return vec2(floor(sx) * 2 + sxf + offs, uv.y);
}

void main(void)
{
    vec2 p = uv2tri(gl_FragCoord.xy * 8 / resolution.y);
    float t = (1.2 + 3.3 * rand(floor(p))) * time;
    float c = max(0, sin(t));
    fragColor = vec4(c);
}
