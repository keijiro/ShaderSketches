#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 hue2rgb(float h)
{
    h = fract(h) * 6 - 2;
    return clamp(vec3(abs(h - 1) - 1, 2 - abs(h), 2 - abs(h - 2)), 0, 1);
}

vec3 eyes(vec2 coord)
{
    const float pi = 3.141592;
    float t = 0.4 * time; 
    float div = 5 - cos(t * 0.33 * pi) * 4;
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
    c = clamp(min(min(c, gr.x), gr.y), 0, 1);

    return hue2rgb(rand(floor(p) * 0.3231)) * c;
}

void main(void)
{
    fragColor = vec4(eyes(gl_FragCoord.xy), 1);
}
