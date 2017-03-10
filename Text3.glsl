#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float glyph(vec2 coord)
{
    float chars = 25;
    float size = resolution.x / chars;

    // time
    float gt = time * 3.5; // global
    float ct = floor(gt); // coarse
    float rt = fract(gt); // repeated

    // position
    vec2 gp = floor(coord / size * 7); // global
    vec2 cp = floor(coord / size); // coarse
    vec2 rp = floor(fract(coord / size) * 7); // repeated
    vec2 odd = fract(rp * 0.5) * 2; // odd/even

    // scrolling
    vec2 gp2 = gp - vec2(0, ct * 7); // global (scrolled)
    vec2 cp2 = cp - vec2(0, ct); // coarse (scrolled)

    float c = max(odd.x, odd.y); // 2x2 grid
    c *= step(0.5, rand(gp2)); // random removal
    c += min(odd.x, odd.y); // border and center points

    c *= rp.x * (6 - rp.x); // cropping
    c *= rp.y * (6 - rp.y);

    c *= max(step(1, cp.y), step(cp.x, chars * rt)); // 1st line anim
    c *= step(0.15, rand(cp2 * 10)); // space
    c *= step(cp.x, rand(cp2.yy * 10) * 10 + 10); // line end

    float flicker = sin(time * 100 + coord.y * 3.1416 * 0.3) * 20 + 0.5;
    c = clamp(clamp(c, 0, 1) * flicker, 0, 1);

    return c;
}

void main(void)
{
    fragColor = vec4(0, glyph(gl_FragCoord.xy), 0, 1);
}
