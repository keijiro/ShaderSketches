#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

void main(void)
{
    const float pi = 3.14159265359;
    float size = resolution.y / 10; // cell size in pixel

    vec2 p1 = gl_FragCoord.xy / size; // normalized pos
    vec2 p2 = fract(p1) - 0.5; // relative pos from cell center

    // random number
    float rnd = dot(floor(p1), vec2(12.9898, 78.233));
    rnd = fract(sin(rnd) * 43758.5453);

    // rotation matrix
    float phi = rnd * pi * 2 + time * 0.4;
    mat2x2 rot = mat2x2(cos(phi), -sin(phi), sin(phi), cos(phi));

    vec2 p3 = rot * p2; // apply rotation
    p3.y += sin(p3.x * 5 + time * 2) * 0.12; // wave

    float rep = fract(rnd * 13.285) * 8 + 2; // line repetition
    float gr = fract(p3.y * rep + time * 0.8); // repeating gradient

    // make antialiased line by saturating the gradient
    float c = clamp((0.25 - abs(0.5 - gr)) * size * 0.75 / rep, 0, 1);
    c *= max(0, 1 - length(p2) * 0.6); // darken corners

    vec2 bd = (0.5 - abs(p2)) * size - 2; // border lines
    c *= clamp(min(bd.x, bd.y), 0, 1);

    fragColor = vec4(c);
}
