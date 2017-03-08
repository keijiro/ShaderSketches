#version 150

const float PI = 3.141592;
uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

void main(void)
{
    vec2 coord = gl_FragCoord.xy;
    vec2 size = resolution.xx / vec2(60, 15);

    float y = coord.y / size.y;
    float scr = 3 + 3 * fract(floor(y) * 12433.34);
    float x = coord.x / size.x + scr * time;
 
    float t = time * 1.1;
    float t01 = fract(t);
    float phase = floor(x) * 2353.48272 + floor(y) * 2745.32782 + floor(t);

    float h = mix(
        fract(sin(phase    ) * 1423.84),
        fract(sin(phase + 1) * 1423.84),
        smoothstep(0.8, 1, t01) * 1.3 - smoothstep(0.5, 0.8, t01) * 0.3
    );

    float c1 = (0.4 - abs(0.4 - fract(x))) / 0.8 * size.x;
    float c2 = (h - fract(y)) * size.y;
    float c = clamp(c1, 0, 1) * clamp(c2, 0, 1);

    fragColor = vec4(c, c, c, 1);
}
