#version 150

uniform vec2 resolution;
uniform float time;
out vec4 fragColor;

vec2 fade(vec2 x) { return x * x * x * (x * (x * 6 - 15) + 10); }

vec2 phash(vec2 p)
{
    p = fract(mat2(1.2989833, 7.8233198, 6.7598192, 3.4857334) * p);
    p = ((2384.2345 * p - 1324.3438) * p + 3884.2243) * p - 4921.2354;
    return normalize(fract(p) * 2 - 1);
}

float noise(vec2 p)
{
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    float d00 = dot(phash(ip), fp);
    float d01 = dot(phash(ip + vec2(0, 1)), fp - vec2(0, 1));
    float d10 = dot(phash(ip + vec2(1, 0)), fp - vec2(1, 0));
    float d11 = dot(phash(ip + vec2(1, 1)), fp - vec2(1, 1));
    fp = fade(fp);
    return mix(mix(d00, d01, fp.y), mix(d10, d11, fp.y), fp.x);
}

void main(void)
{
    vec2 p = vec2(gl_FragCoord.xy * 10 / resolution.y) + vec2(time * 2 - 10);
    fragColor = vec4(noise(p) / 2 + 0.5);
}
