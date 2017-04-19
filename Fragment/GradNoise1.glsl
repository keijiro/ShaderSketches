#version 150

uniform vec2 resolution;
uniform float time;
out vec4 fragColor;

float fade(float x) { return x * x * x * (x * (x * 6 - 15) + 10); }

float phash(float p)
{
    p = fract(7.8233139 * p);
    p = ((2384.2345 * p - 1324.3438) * p + 3884.2243) * p - 4921.2354;
    return fract(p) * 2 - 1;
}

float noise(float p)
{
    float ip = floor(p);
    float fp = fract(p);
    float d0 = phash(ip    ) *  fp;
    float d1 = phash(ip + 1) * (fp - 1);
    return mix(d0, d1, fade(fp));
}

void main(void)
{
    float p = gl_FragCoord.x * 10 / resolution.x;
    p += time * 2 - 10;
    fragColor = vec4(noise(p) / 2 + 0.5);
}
