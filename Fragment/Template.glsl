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

const float PI = 3.14159265359;
const vec4 C1 = vec4(0, 1, 0.5, -1);

float saturate(float x) { return clamp(x, 0, 1); }
vec2  saturate(vec2 x)  { return clamp(x, 0, 1); }
vec3  saturate(vec3 x)  { return clamp(x, 0, 1); }
vec4  saturate(vec4 x)  { return clamp(x, 0, 1); }

vec3 max4(vec3 a, vec3 b, vec3 c, vec3 d)
{
    return max(max(max(a, b), c), d);
}

vec3 mix4(vec3 a, vec3 b, vec3 c, vec3 d, float t)
{
    t = fract(t / 4) * 4;
    vec3 acc = mix(a, b, saturate(t));
    acc = mix(acc, c, saturate(t - 1));
    acc = mix(acc, d, saturate(t - 2));
    acc = mix(acc, a, saturate(t - 3));
    return acc;
}

vec2 sincos(float x) { return vec2(sin(x), cos(x)); }

mat2 rotate(float x)
{
    vec2 sc = sincos(x);
    return mat2(sc.y, sc.x, -sc.x, sc.y);
}

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float rand(float x, float y = 0)
{
    return rand(vec2(x, y));
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

vec3 sample(sampler2D t, vec2 uv)
{
    return texture(t, fract(1 - uv)).rgb;
}

vec3 feedback(vec2 offs)
{
    vec2 uv = gl_FragCoord.xy / resolution;
    offs.x *= resolution.x / resolution.y;
    return texture(prevFrame, fract(uv + offs)).rgb;
}

vec2 uv2rect(vec2 uv)
{
    vec2 p = uv * 2 - 1;
    p.x *= resolution.x / resolution.y;
    return p;
}

vec2 uv2polar(vec2 uv)
{
    vec2 p = uv * 2 - 1;
    p.x *= resolution.x / resolution.y;
    return vec2(atan(p.y, p.x) / PI / 2 + 0.5, length(p));
}

vec2 uv2tri(vec2 uv)
{
    vec2 p = uv2rect(uv);
    float sx = p.x - p.y / 2; // skewed x
    float offs = step(fract(1 - p.y), fract(sx));
    // distance from borders
    vec3 tp = vec3(dot(p, vec2(1, 0.5)), dot(p, vec2(-1, 0.5)), p.y);
    vec3 tp1 = fract(+tp);
    vec3 tp2 = fract(-tp);
    float d1 = min(min(tp1.x, tp1.y), tp1.z);
    float d2 = min(min(tp2.x, tp2.y), tp2.z);
    float d = min(d1, d2) * 3;
    return vec2(floor(sx) * 2 + offs, floor(p.y)) + d;
}

vec2 uv2hex(vec2 uv)
{
    vec2 p = uv * 2 - 1;
    p.x *= resolution.x / resolution.y;
    float seg = floor(fract(atan(p.y, p.x) / PI / 2 + 0.5 / 6) * 6);
    vec2 v1 = sincos(seg / 6 * PI * 2).yx;
#if 0
    vec2 v2 = vec2(-v1.y, v1.x) * 0.86602540378; // sin(60 degs);
    return vec2(dot(p, v2) / dot(p, v1) + 0.5 + seg, dot(p, v1));
#else
    vec2 v2 = vec2(-v1.y, v1.x);
    return vec2(dot(p, v2) * 0.5 + 0.5 + seg, dot(p, v1));
#endif
}

vec3 render(vec2 uv);

void main(void)
{
    fragColor = vec4(render(gl_FragCoord.xy / resolution), 1);
}

//
//
//

vec3 render(vec2 uv)
{
    return vec3(1) * cnoise(uv.x * 4 + time);
}

