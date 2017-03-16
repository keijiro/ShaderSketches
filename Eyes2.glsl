#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float eyes(vec2 coord)
{
    const float pi = 3.141592;
    float t = 0.4 * time; 
    float div = 5 - cos(t * 0.25 * pi) * 4;
    float sc = resolution.y / div;

    vec2 p = (coord - resolution / 2) / sc - 0.5;

    // center offset
    float dir = floor(rand(floor(p) + floor(t) * 0.11) * 4) * pi / 2;
    vec2 offs = vec2(sin(dir), cos(dir)) * 0.6;
    offs *= smoothstep(0.0, 0.1,     fract(t));
    offs *= smoothstep(0.4, 0.5, 1 - fract(t));

    // circles
    float l = length(fract(p) + offs - 0.5);
    float rep = sin((rand(floor(p)) * 2 + 2) * t) * 4 + 5;
    float c = (abs(0.5 - fract(l * rep + 0.5)) - 0.25) * sc / rep;

    // grid lines
    vec2 gr = (abs(0.5 - fract(p + 0.5)) - 0.05) * sc;

    return min(min(c, gr.x), gr.y);
}

void main(void)
{
    fragColor = vec4(eyes(gl_FragCoord.xy));
}
