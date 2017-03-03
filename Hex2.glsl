#version 150

const float PI = 3.141592;
uniform float time;
uniform vec2 resolution;

out vec4 fragColor;

void main(void)
{
    vec2 coord = gl_FragCoord.xy - resolution * 0.5;

    float phi = atan(coord.y, coord.x + 1e-6);
    phi = phi / PI * 0.5 + 0.5;
    float seg = floor(phi * 6);

    float theta = (seg + 0.5) / 6 * PI * 2;
    vec2 dir1 = vec2(cos(theta), sin(theta));
    vec2 dir2 = vec2(-dir1.y, dir1.x);

    float l = dot(dir1, coord);
    float w = sin(seg * 31.374) * 18 + 20;
    float prog = l / w + time * 2;
    float idx = floor(prog);

    float phase = time * 0.8;
    float th1 = fract(273.84937 * sin(idx * 54.67458 + floor(phase    )));
    float th2 = fract(273.84937 * sin(idx * 54.67458 + floor(phase + 1)));
    float thresh = mix(th1, th2, smoothstep(0.75, 1, fract(phase)));

    float l2 = dot(dir2, coord);
    float slide = fract(idx * 32.74853) * 200 * time;
    float w2 = fract(idx * 39.721784) * 500;
    float prog2 = (l2 + slide) / w2;

    float c = clamp((fract(prog) - thresh) * w * 0.3, 0, 1);
    c *= clamp((fract(prog2) - 1 + thresh) * w2 * 0.3, 0, 1);

    fragColor = vec4(c, c, c, 1);
}
