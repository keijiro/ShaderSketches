#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float letter(vec2 coord)
{
    float size = resolution.x / 25;

    vec2 gp = floor(coord / size * 7); // global
    vec2 rp = floor(fract(coord / size) * 7); // repeated

    vec2 odd = fract(rp * 0.5) * 2;
    float rnd = fract(sin(dot(gp, vec2(12.9898, 78.233))) * 43758.5453);

    float c = max(odd.x, odd.y) * step(0.5, rnd); // random lines
    c += min(odd.x, odd.y); // corder and center points

    c *= rp.x * (6 - rp.x); // cropping
    c *= rp.y * (6 - rp.y);

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
