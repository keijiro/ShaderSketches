#version 150

uniform vec2 resolution;
out vec4 fragColor;

vec2 rand(vec2 uv)
{
    vec2 p = fract(mat2(1.29898, 7.82331, 2.35623, 6.75981) * uv);
    p = ((2384.2345 * p - 1324.3438) * p + 3884.2243) * p - 4921.2354;
    return normalize(fract(p) * 2 - 1);
}

float noise(vec2 p)
{
    vec2 ip = floor(p);
    vec2 fp = p - ip;

    float d00 = dot(rand(ip), fp);
    float d01 = dot(rand(ip + vec2(0, 1)), fp - vec2(0, 1));
    float d10 = dot(rand(ip + vec2(1, 0)), fp - vec2(1, 0));
    float d11 = dot(rand(ip + vec2(1, 1)), fp - vec2(1, 1));

    fp = smoothstep(0, 1, fp);
    return mix(mix(d00, d01, fp.y), mix(d10, d11, fp.y), fp.x);
}

void main(void)
{
    vec2 p = gl_FragCoord.xy * 20 / resolution.y;
    fragColor = vec4(noise(p) / 2 + 0.5);
}
