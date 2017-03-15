#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float eyes(vec2 coord)
{
    float div = 8 - cos(time * 0.3) * 7;
    float sc = resolution.y / div;
    vec2 p = (coord - resolution / 2) / sc;

    // circles
    float l = length(fract(p - 0.5) - 0.5);
    float rep = sin(dot(floor(p - 0.5), vec2(9.1, 7.9)) + time) * 5 + 8;
    float c = (abs(0.5 - fract(l * rep + 0.5)) - 0.25) * sc / rep;

    // grid lines
    vec2 gr = (abs(0.5 - fract(p)) - 0.05) * sc;

    return min(min(c, gr.x), gr.y);
}

void main(void)
{
    fragColor = vec4(eyes(gl_FragCoord.xy));
}
