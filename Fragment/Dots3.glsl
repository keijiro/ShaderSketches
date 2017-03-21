#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float smin(float a, float b, float k)
{
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0, 1);
    return mix(b, a, h) - k * h * (1 - h);
}

float swirl(vec2 coord)
{
    float l = length(coord) / resolution.x;
    float phi = atan(coord.y, coord.x + 1e-6);
    return sin(l * 21 + phi * 5 - time * 4) * 0.5 + 0.5;
}

float halftone(vec2 coord, float size, vec2 offs)
{
    vec2 uv = coord / size;
    vec2 ip = floor(uv) + offs; // column, row
    vec2 odd = vec2(0.5 * mod(ip.y, 2), 0); // odd line offset
    vec2 cp = floor(uv - odd + offs) + odd; // dot center
    float d = length(uv - cp - 0.5) * size; // distance
    float r = swirl(cp * size) * size * 0.6; // dot radius
    return max(0, d - r);
}

void main(void)
{
    vec2 coord = gl_FragCoord.xy - resolution * 0.5;
    float size = resolution.x / (30 + sin(time * 0.5) * 20);
    float k = size / 4;

    float d =   halftone(coord, size, vec2(-0.5, -1));
    d = smin(d, halftone(coord, size, vec2( 0.5, -1)), k);
    d = smin(d, halftone(coord, size, vec2(-1.0,  0)), k);
    d = smin(d, halftone(coord, size, vec2( 0.0,  0)), k);
    d = smin(d, halftone(coord, size, vec2( 1.0,  0)), k);
    d = smin(d, halftone(coord, size, vec2(-0.5,  1)), k);
    d = smin(d, halftone(coord, size, vec2( 0.5,  1)), k);

    fragColor = vec4(d, d, d, 1);
}
