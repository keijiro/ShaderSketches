#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float letter(vec2 coord)
{
    float size = resolution.x / 25;
    vec2 c_i = floor(coord / size);
    vec2 c_f = fract(coord / size);
    vec2 p_i = floor(c_f * 7);

    vec2 c2 = fract(p_i * 0.5) * 2;
    float r = fract(
        sin(dot(c_i, vec2(82.1632, 74.3824)) * 12.83) * 374.26 +
        sin(dot(p_i, vec2(22.7549, 52.8241)) * 21.37) * 284.92
    );

    float c = max(c2.x, c2.y) * step(0.5, r);
    c += min(c2.x, c2.y);
    c *= p_i.x * (6 - p_i.x);
    c *= p_i.y * (6 - p_i.y);
    return clamp(c, 0, 1);
}

void main(void)
{
    vec2 coord = gl_FragCoord.xy;
    coord.x += resolution.x * 0.1 * time;

    float c; // MSAA with 2x2 RGSS sampling pattern
    c  = letter(coord + vec2(-3.0 / 8, -1.0 / 8));
    c += letter(coord + vec2( 1.0 / 8, -3.0 / 8));
    c += letter(coord + vec2( 3.0 / 8,  1.0 / 8));
    c += letter(coord + vec2(-1.0 / 8,  3.0 / 8));
    fragColor = vec4(c / 4);
}
