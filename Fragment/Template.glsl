#version 150

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec3 spectrum;
uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform sampler2D prevFrame;

out vec4 fragColor;

float saturate(float x) { return clamp(x, 0, 1); }
vec2 saturate(vec2 x) { return clamp(x, 0, 1); }
vec3 saturate(vec3 x) { return clamp(x, 0, 1); }
vec4 saturate(vec4 x) { return clamp(x, 0, 1); }

vec2 sincos(float x) { return vec2(sin(x), cos(x)); }

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 fade(vec2 x) { return x * x * x * (x * (x * 6 - 15) + 10); }
vec3 fade(vec3 x) { return x * x * x * (x * (x * 6 - 15) + 10); }

vec2 phash(vec2 p)
{
    p = fract(mat2(1.2989833, 7.8233198, 6.7598192, 3.4857334) * p);
    p = ((2384.2345 * p - 1324.3438) * p + 3884.2243) * p - 4921.2354;
    return normalize(fract(p) * 2 - 1);
}

vec3 phash(vec3 p)
{
    p = fract(mat3(1.2989833, 7.8233198, 2.3562332,
                   6.7598192, 3.4857334, 8.2837193,
                   2.9175399, 2.9884245, 5.4987265) * p);
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

float noise(vec3 p)
{
    vec3 ip = floor(p);
    vec3 fp = fract(p);
    float d000 = dot(phash(ip), fp);
    float d001 = dot(phash(ip + vec3(0, 0, 1)), fp - vec3(0, 0, 1));
    float d010 = dot(phash(ip + vec3(0, 1, 0)), fp - vec3(0, 1, 0));
    float d011 = dot(phash(ip + vec3(0, 1, 1)), fp - vec3(0, 1, 1));
    float d100 = dot(phash(ip + vec3(1, 0, 0)), fp - vec3(1, 0, 0));
    float d101 = dot(phash(ip + vec3(1, 0, 1)), fp - vec3(1, 0, 1));
    float d110 = dot(phash(ip + vec3(1, 1, 0)), fp - vec3(1, 1, 0));
    float d111 = dot(phash(ip + vec3(1, 1, 1)), fp - vec3(1, 1, 1));
    fp = fade(fp);
    return mix(mix(mix(d000, d001, fp.z), mix(d010, d011, fp.z), fp.y),
               mix(mix(d100, d101, fp.z), mix(d110, d111, fp.z), fp.y), fp.x);
}

void main(void)
{
    vec2 p = gl_FragCoord.xy * 10 / resolution.y;
    float c = noise(vec3(p, time)) + 0.5;
    vec3 rgb = vec3(c);
    fragColor = vec4(rgb, 1);
}
