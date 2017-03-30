#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

void main(void)
{
    const float pi = 3.1415926;
    float t = time * 0.7;

    float scale = 10 / resolution.y;
    vec2 p = gl_FragCoord.xy * scale + 0.5; // pos normalized /w grid
    p += vec2(2, 0.5) * time;

    float rnd = fract(sin(dot(floor(p), vec2(21.98, 19.37))) * 4231.73);
    float flip = fract(rnd * 13.8273) > 0.5 ? 1 : -1;
    rnd = floor(rnd * 2) / 2 + floor(t) * flip / 2;

    float anim = smoothstep(0, 0.66, fract(t));
    float phi = pi * (rnd + anim * flip / 2 + 0.25);
    vec2 offs = vec2(cos(phi), sin(phi)) * sqrt(2) / 2;

    vec2 pf = fract(p);
    float d1 = abs(0.5 - distance(pf, vec2(0.5 - offs))); // arc 1
    float d2 = abs(0.5 - distance(pf, vec2(0.5 + offs))); // arc 2

    float w = 0.1 + 0.08 * sin(t);
    fragColor = vec4((w - min(d1, d2)) / scale);
}
