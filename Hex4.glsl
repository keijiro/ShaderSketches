#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

vec3 hue2rgb(float h)
{
    h = fract(h) * 6 - 2;
    return clamp(vec3(abs(h - 1) - 1, 2 - abs(h), 2 - abs(h - 2)), 0, 1);
}

void main(void)
{
    const float pi = 3.1415926535;
    vec2 p = gl_FragCoord.xy - resolution / 2;
    float phi = atan(p.y, p.x + 1e-5);

    float fin = mod(floor(phi * 3 / pi + 0.5), 6);
    float phi_fin = fin * pi / 3;

    vec2 dir = vec2(cos(phi_fin), sin(phi_fin));
    float l = dot(dir, p) - time * resolution.y / 8;
    float seg = floor(l * 40 / resolution.y);

    float th = sin(time) * 0.4 + 0.5;
    float t = sin(seg * 92.198763) * time;

    vec3 c  = hue2rgb(sin(seg * 99.374662) * 237.28364);
    c *= step(th, fract(phi / pi / 2 + t));

    fragColor = vec4(c, 1);
}
