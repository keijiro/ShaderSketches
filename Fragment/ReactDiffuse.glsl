#version 150

uniform float time;
uniform vec2 resolution;
uniform sampler2D prevFrame;
out vec4 fragColor;

float rand(vec2 uv)
{
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 ReactDiffuse(vec2 p)
{
    vec4 duv = vec4(1, 1, -1, 0) / resolution.xyxy;

    vec2 s = texture(prevFrame, p).xy;

    vec2 lpc =
        texture(prevFrame, p - duv.xy).xy * 0.05 +
        texture(prevFrame, p - duv.wy).xy * 0.20 +
        texture(prevFrame, p - duv.zy).xy * 0.05 +

        texture(prevFrame, p - duv.xw).xy * 0.20 +
        s * -1 +
        texture(prevFrame, p + duv.xw).xy * 0.20 +

        texture(prevFrame, p + duv.zy).xy * 0.05 +
        texture(prevFrame, p + duv.wy).xy * 0.20 +
        texture(prevFrame, p + duv.xy).xy * 0.05;

    const float f = 0.0545;
    const float k = 0.0650;

    s += vec2(
        lpc.x * 1.00 - s.x * s.y * s.y + f * (1 - s.x),
        lpc.y * 0.3 + s.x * s.y * s.y - (k + f) * s.y
    );

    return s;
}

void main(void)
{
    bool initiate = false;

    // *** TO INITIATE THE STATE, ENABLE THE LINE BELOW. ***
    //initiate = true;

    vec2 uv = gl_FragCoord.xy / resolution;

    if (initiate)
    {
        fragColor = vec4(1, step(0.9, rand(uv + time * 0.01)), 0, 0);
    }
    else if (uv.x < 0.5)
    {
        fragColor = vec4(ReactDiffuse(uv), 0, 0);
    }
    else
    {
        vec2 s = texture(prevFrame, uv - vec2(0.5, 0)).xy;
        float c = smoothstep(-0.2, 0.2, s.y - s.x);
        fragColor = vec4(c, c, c, 1);
    }
}
