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

vec2 frag2uv(vec2 coord)
{
    return (coord - resolution / 2) / resolution.y * 2;
}

vec2 frag2polar(vec2 coord)
{
    vec2 p = (coord - resolution / 2) / resolution.y * 2;
    return vec2(atan(p.y, p.x) / PI / 2 + 1, length(p));
}

vec2 frag2hex(vec2 coord)
{
    vec2 p = (coord - resolution / 2) / resolution.y;
    float seg = floor(fract(atan(p.y, p.x) / PI / 2 + 0.5 / 6) * 6);
    vec2 v1 = sincos(seg / 6 * PI * 2).yx;
    vec2 v2 = vec2(-v1.y, v1.x);
    return vec2(dot(p, v2) + 0.5 + seg, dot(p, v1));
}

/*
    vec2 p = frag2uv(coord) * vec2(4, 4);
    vec2 pc = floor(p);
    vec2 pf = fract(p);

    float t = time * 2;
    float tc = floor(t);
    float tf = fract(t);

    vec3 c = C1.xxx;

    c = C1.yyy * 0;

    return saturate(c);
*/

/*
 ____  __.         .___     .____    .__  _____        ____  ___  ____ ___      .__  __                                                 
|    |/ _|____   __| _/____ |    |   |__|/ ____\____   \   \/  / |    |   \____ |__|/  |_ ___.__.                                       
|      < /  _ \ / __ |/ __ \|    |   |  \   __\/ __ \   \     /  |    |   /    \|  \   __<   |  |                                       
|    |  (  <_> ) /_/ \  ___/|    |___|  ||  | \  ___/   /     \  |    |  /   |  \  ||  |  \___  |                                       
|____|__ \____/\____ |\___  >_______ \__||__|  \___  > /___/\  \ |______/|___|  /__||__|  / ____|                                       
        \/          \/    \/        \/             \/        \_/              \/          \/                                            
.____    .__             _________            .___.__              ___________                           .__                            
|    |   |__|__  __ ____ \_   ___ \  ____   __| _/|__| ____    ____\_   _____/__  _________   ___________|__| ____   ____   ____  ____  
|    |   |  \  \/ // __ \/    \  \/ /  _ \ / __ | |  |/    \  / ___\|    __)_\  \/  /\____ \_/ __ \_  __ \  |/ __ \ /    \_/ ___\/ __ \ 
|    |___|  |\   /\  ___/\     \___(  <_> ) /_/ | |  |   |  \/ /_/  >        \>    < |  |_> >  ___/|  | \/  \  ___/|   |  \  \__\  ___/ 
|_______ \__| \_/  \___  >\______  /\____/\____ | |__|___|  /\___  /_______  /__/\_ \|   __/ \___  >__|  |__|\___  >___|  /\___  >___  >
        \/             \/        \/            \/         \//_____/        \/      \/|__|        \/              \/     \/     \/    \/ 
*/

vec3 fx1(vec2 coord)
{
    vec2 p = frag2uv(coord) * vec2(4, 4);
    vec2 pc = floor(p);
    vec2 pf = fract(p);

    float t = time * 2;
    float tc = floor(t);
    float tf = fract(t);

    vec3 c = C1.xxx;

    c = C1.yyy * spectrum.x;

    return saturate(c);
}

vec3 fx2(vec2 coord)
{
    vec2 p = frag2uv(coord) * vec2(4, 4);
    vec2 pc = floor(p);
    vec2 pf = fract(p);

    float t = time * 2;
    float tc = floor(t);
    float tf = fract(t);

    vec3 c = C1.xxx;

    c = C1.yyy * 0;

    return saturate(c);
}

vec3 fx3(vec2 coord)
{
    vec2 p = frag2uv(coord) * vec2(4, 4);
    vec2 pc = floor(p);
    vec2 pf = fract(p);

    float t = time * 2;
    float tc = floor(t);
    float tf = fract(t);

    vec3 c = C1.xxx;

    c = C1.yyy * 0;

    return saturate(c);
}

vec3 fx4(vec2 coord)
{
    vec2 p = frag2uv(coord) * vec2(4, 4);
    vec2 pc = floor(p);
    vec2 pf = fract(p);

    float t = time * 2;
    float tc = floor(t);
    float tf = fract(t);

    vec3 c = C1.xxx;

    c = C1.yyy * 0;

    return saturate(c);
}

void main(void)
{
    vec2 p0 = gl_FragCoord.xy;

    vec2 p1 = p0 + C1.ww / 4;
    vec2 p2 = p0 + C1.yw / 4;
    vec2 p3 = p0 + C1.yy / 4;
    vec2 p4 = p0 + C1.wy / 4;

    #define NOAA(func) (func(p0))
    #define SSAA(func) ((func(p1)+func(p2)+func(p3)+func(p4))/4)

    vec3 c1 = NOAA(fx1);
    vec3 c2 = NOAA(fx2);
    vec3 c3 = NOAA(fx3);
    vec3 c4 = NOAA(fx4);

    #undef NOAA
    #undef SSAA

    #if 1

    vec3 acc = max(max(max(c1, c2), c3), c4);

    #else

    float bp = fract(time) * 4;
    vec3 acc = mix(c1, c2, saturate(bp));
    acc = mix(acc, c3, saturate(bp - 1));
    acc = mix(acc, c4, saturate(bp - 2));
    acc = mix(acc, c1, saturate(bp - 3));

    #endif

    fragColor = vec4(acc, 1);
}
