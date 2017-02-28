#version 150

uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

float swirl(vec2 coord)
{
    float l = length(coord) / resolution.x;
    float phi = atan(coord.y, coord.x + 1e-6);
    return sin(l * 10 + phi - time * 4) * 0.5 + 0.5;
}

float halftone(vec2 coord)
{
    coord -= resolution * 0.5;
    float size = resolution.x / (60 + sin(time * 0.5) * 50);
    vec2 uv = coord / size; 
    vec2 ip = floor(uv); // column, row
    vec2 odd = vec2(0.5 * mod(ip.y, 2), 0); // odd line offset
    vec2 cp = floor(uv - odd) + odd; // dot center
    float d = length(uv - cp - 0.5) * size; // distance
    float r = swirl(cp * size) * (size - 2) * 0.5; // dot radius
    return clamp(d - r, 0, 1);
}

void main(void)
{
    fragColor = vec4(vec3(1, 1, 0) * halftone(gl_FragCoord.xy), 1);
}
