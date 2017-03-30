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
    float phi = pi * (rnd + anim * flip / 2);
    vec2 a1 = vec2(cos(phi), sin(phi));
    vec2 a2 = vec2(-a1.y, a1.x);
    vec2 a3 = vec2(cos(phi + pi / 4), sin(phi + pi / 4));

    vec2 pf = fract(p) - 0.5;
    float d1 = abs(min(min(dot( pf, a1), dot( pf, a2)), dot( pf, a3) - 0.2));
    float d2 = abs(min(min(dot(-pf, a1), dot(-pf, a2)), dot(-pf, a3) - 0.2));

    float w = 0.1 + sin(t) * 0.08; // line width
    float c = 1 - clamp((w - min(d1, d2)) / scale, 0, 1);
    fragColor = vec4(c, 0.5 * c, 0, 1);
}
