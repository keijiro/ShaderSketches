#version 150

uniform vec2 resolution;
out vec4 fragColor;

void main(void)
{
    float scale = 13.5 / resolution.y;
    vec2 p1 = gl_FragCoord.xy * scale - vec2(11.5, 6.25);
    vec2 p2 = fract(p1);
    vec2 p3 = floor(p1);

    // gray background
    float c = 0.5;

    // grid lines (2 pixel width)
    vec2 grid = step(2, p2 / 13.5 * resolution.y);
    c += 2 - grid.x - grid.y;

    // overscan checkers
    vec2 checker_v = step(0.49999, fract(p3 * 0.5));
    float checker = abs(checker_v.x - checker_v.y);
    vec2 over = step(vec2(12, 7), abs(p3));
    c = mix(c, checker, max(over.x, over.y));

    // antialiased mask for big circle (radius = 6)
    float mask = 1 - clamp((length(p1 - vec2(0.5)) - 6) / scale /2, 0, 1);

    vec3 rgb = vec3(c);

    // grid lines inside the circle
//    grid = step(2, fract(p1 - vec2(0, 0.5)) / 13.5 * resolution.y);
    rgb = mix(rgb, vec3(2 - grid.x - grid.y), mask * step(0, p3.y));

    // primitive color bar
    vec3 pcbar = step(0.4999, fract(vec3(0.25, 0.125, 0.5) * (8.5 - p1.x) * 0.5));
    rgb = mix(rgb, pcbar, mask * step(1, p3.y));

    fragColor = vec4(rgb, 1);
}
