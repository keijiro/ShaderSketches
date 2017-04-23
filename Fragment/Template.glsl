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

const float pi = 3.14159265359;
const vec4 qr = vec4(0, 1, 0.5, -1);

float saturate(float x) { return clamp(x, 0, 1); }
vec2  saturate(vec2 x)  { return clamp(x, 0, 1); }
vec3  saturate(vec3 x)  { return clamp(x, 0, 1); }
vec4  saturate(vec4 x)  { return clamp(x, 0, 1); }

vec2 sincos(float x) { return vec2(sin(x), cos(x)); }

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 hue2rgb(float h)
{
    h = fract(h) * 6 - 2;
    return saturate(vec3(abs(h - 1) - 1, 2 - abs(h), 2 - abs(h - 2)));
}

float fade(float x) { return x * x * x * (x * (x * 6 - 15) + 10); }
vec2  fade(vec2 x)  { return x * x * x * (x * (x * 6 - 15) + 10); }
vec3  fade(vec3 x)  { return x * x * x * (x * (x * 6 - 15) + 10); }

float phash(float p)
{
    p = fract(7.8233139 * p);
    p = ((2384.2345 * p - 1324.3438) * p + 3884.2243) * p - 4921.2354;
    return fract(p) * 2 - 1;
}

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

float cnoise(float p)
{
    float ip = floor(p);
    float fp = fract(p);
    float d0 = phash(ip    ) *  fp;
    float d1 = phash(ip + 1) * (fp - 1);
    return mix(d0, d1, fade(fp));
}

float cnoise(vec2 p)
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

float cnoise(vec3 p)
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

vec2 ScreenCoord01(vec2 coord)
{
    return (coord - resolution / 2) / resolution.y * 2 - 1;
}

vec2 PolarCoord(vec2 coord)
{
    vec2 p = (coord - resolution / 2) / resolution.y * 2;
    return vec2(atan(p.y, p.x) / pi / 2 + 1, length(p));
}

vec3 HexCoord(vec2 coord)
{
    vec2 p = (coord - resolution / 2) / resolution.y * 2;
    float seg = floor(fract(atan(p.y, p.x) / pi / 2 + 0.5 / 6) * 6) / 6;
    vec2 v1 = sincos(seg * pi * 2).yx;
    vec2 v2 = vec2(-v1.y, v1.x);
    return vec3(dot(p, v2), dot(p, v1), seg);
}

//
//  ____  __.         .___     .____    .__  _____       
// |    |/ _|____   __| _/____ |    |   |__|/ ____\____  
// |      < /  _ \ / __ |/ __ \|    |   |  \   __\/ __ \ 
// |    |  (  <_> ) /_/ \  ___/|    |___|  ||  | \  ___/ 
// |____|__ \____/\____ |\___  >_______ \__||__|  \___  >
//         \/          \/    \/        \/             \/ 
//

vec3 effect1(vec2 coord)
{
    vec3 rgb = vec3(0);
    rgb.rg = fract(ScreenCoord01(coord) + time);
    return rgb / 4;
}

vec3 effect2(vec2 coord)
{
    vec3 rgb = vec3(0);
    rgb.gb = PolarCoord(coord);
    return rgb/ 4;
}

vec3 effect3(vec2 coord)
{
    vec3 rgb = vec3(0);
    rgb = fract(HexCoord(coord) + time);
    return rgb / 4;
}

vec3 effect4(vec2 coord)
{
    vec3 rgb = vec3(0);
    return rgb;
}

void main(void)
{
    vec2 p0 = gl_FragCoord.xy;
    vec2 p1 = p0 + vec2(-3, -1) / 8;
    vec2 p2 = p0 + vec2(+1, -3) / 8;
    vec2 p3 = p0 + vec2(+3, +1) / 8;
    vec2 p4 = p0 + vec2(-1, +3) / 8;

    #define NOAA(func) (func(p0))
    #define SSAA(func) ((func(p1)+func(p2)+func(p3)+func(p4))/4)

    vec3 acc = qr.xxx;

    acc += NOAA(effect1);
    acc += NOAA(effect2);
    acc += NOAA(effect3);
    acc += NOAA(effect4);

    fragColor = vec4(acc, 1);
}
