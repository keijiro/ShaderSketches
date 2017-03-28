#version 150

uniform vec2 resolution;
out vec4 fragColor;

float saturate(float x) { return clamp(x, 0, 1); }
vec3 saturate(vec3 x) { return clamp(x, 0, 1); }

vec3 hue2rgb(float h)
{
    h = fract(saturate(h)) * 6 - 2;
    return saturate(vec3(abs(h - 1) - 1, 2 - abs(h), 2 - abs(h - 2)));
}

void main(void)
{
    float scale = 27.0 / resolution.y;

    vec2 p0 = gl_FragCoord.xy - resolution * 0.5;
    vec2 p1 = p0 * scale;

    // gray background with center cross
    float gs = 1 - step(2, min(abs(p0.x), abs(p0.y))) * 0.5;

    // grid lines (2 pixel width)
    vec2 grid = step(scale, abs(0.5 - fract(p1 * 0.5)));
    gs += 2 - grid.x - grid.y;

    // castellation
    vec2 checker_v = step(0.49999, fract(floor(p1 * 0.5 + 0.5) * 0.5));
    vec2 over = step(vec2(23, 13), abs(p1));
    gs = mix(gs, abs(checker_v.x - checker_v.y), max(over.x, over.y));

    // corner circles
    float corner = clamp(2 - abs(sqrt(8) - length(abs(p1) - vec2(19, 9))) / scale, 0, 1);
    gs = mix(gs, 1, corner);

    vec3 rgb = vec3(gs);

    // antialiased mask for big circle (radius = 6)
    float mask = 1 - clamp((length(p1) - 12) / scale / 2, 0, 1);

    // grayscale bar
    float gsbar = floor(p1.x / 4 + 3) / 5;
    gsbar = mix(gsbar, clamp(p1.x / 16 + 0.5, 0, 1), step(5, p1.y));
    rgb = mix(rgb, vec3(gsbar), mask * step(1, p1.y) * step(-9, -p1.y));

    // primitive color bar
    vec3 pcbar = step(0.4999, fract(vec3(0.25, 0.125, 0.5) * (16 - p1.x) * 0.25));
    pcbar = mix(pcbar, hue2rgb(p1.x / 16 + 0.5), step(5, -p1.y));
    rgb = mix(rgb, pcbar, mask * step(1, -p1.y) * step(-9, p1.y));

    // big center circle
    float circle = saturate(4 - abs(12 - length(p1)) / scale);
    rgb = mix(rgb, vec3(1), circle);

    fragColor = vec4(rgb, 1);
}
