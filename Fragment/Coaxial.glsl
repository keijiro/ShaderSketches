#version 150

uniform float time;
uniform vec2 resolution;
out vec4 fragColor;

float uvrand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float arc(vec2 coord)
{
    const float pi = 3.1415926;
    float t = floor(time * 1.1) * 7.3962;

    vec2 sc = (coord.xy - resolution / 2) / resolution.y;
    float phi = atan(sc.y, sc.x + 1e-6);
    vec2 pc = vec2(fract(phi / (pi * 2) + time * 0.07), length(sc));

    vec2 org = vec2(0.5, 0.5);
    vec2 wid = vec2(0.5, 0.5);

    for (int i = 0; i < 7; i++)
    {
        if (uvrand(org + t) < 0.04 * i) break;
        wid *= 0.5;
        org += wid * (step(org, pc) * 2 - 1);
    }

    return uvrand(org);
}

void main(void)
{
    vec4 delta = vec4(-1, -1, 1, 1) * 0.5;

    // neightbor four samples
    float c1 = arc(gl_FragCoord.xy + delta.xy);
    float c2 = arc(gl_FragCoord.xy + delta.zy);
    float c3 = arc(gl_FragCoord.xy + delta.xw);
    float c4 = arc(gl_FragCoord.xy + delta.zw);

    // roberts cross operator
    float gx = c1 - c4;
    float gy = c2 - c3;
    float g = sqrt(gx * gx + gy * gy);

    fragColor = vec4(g * 4);
}
