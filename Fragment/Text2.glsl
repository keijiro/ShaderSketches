#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float letter(vec2 coord)
{
    float size = resolution.x / 25;

    float gt = time * 0.3; // global
    float ct = floor(gt); // coarse
    float rt = fract(gt); // repeated

    vec2 gp = floor(coord / size * 7); // global
    vec2 cp = floor(coord / size); // coarse
    vec2 rp = floor(fract(coord / size) * 7); // repeated
    vec2 odd = fract(rp * 0.5) * 2;

    float th = (1 - pow(rand(cp + ct * 0.82), 3)) * 0.7;
    float amp = smoothstep(th, th + 0.03, rt);
    amp *= smoothstep(0, 0.05, 1 - rt);

    float c = max(odd.x, odd.y); // 2x2 grid
    c *= step(0.5, rand(gp + 0.1 * ct)); // random removal
    c += min(odd.x, odd.y); // border and center points

    c *= rp.x * (6 - rp.x); // cropping
    c *= rp.y * (6 - rp.y);

    return clamp(c, 0, 1) * amp;
}

void main(void)
{
    vec2 coord = gl_FragCoord.xy;
    float c; // MSAA with 2x2 RGSS sampling pattern
    c  = letter(coord + vec2(-3.0 / 8, -1.0 / 8));
    c += letter(coord + vec2( 1.0 / 8, -3.0 / 8));
    c += letter(coord + vec2( 3.0 / 8,  1.0 / 8));
    c += letter(coord + vec2(-1.0 / 8,  3.0 / 8));
    fragColor = vec4(c / 4);
}
