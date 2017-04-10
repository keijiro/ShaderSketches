#version 150

uniform vec2 resolution;
uniform vec3 spectrum;
uniform sampler2D prevFrame;
out vec4 fragColor;

void main(void)
{
    const int rep = 12;

    vec2 p = gl_FragCoord.xy;
    vec3 sp = spectrum * vec3(2, 8, 256);
    vec3 c;

    if (p.x < 1)
    {
        // the first column is used for storing history
        vec3 prev = texture(prevFrame, vec2(p.x, p.y - 1) / resolution).rgb;
        c = mix(sp, prev, min(1, p.y + 0.25));
    }
    else
    {
        p /= resolution;
        c = vec3(0);

        for (int i = 0; i < rep; i++)
        {
            float i01 = i * 1.0 / rep;

            // sample the history column
            sp = texture(prevFrame, vec2(0, i * 2.0 / resolution.y)).xyz;

            // three points curve
            float px = p.x * 3 - i01 * 0.25;
            float lv = mix(sp.x, sp.y, smoothstep(0, 1.5, px));
            lv = mix(lv, sp.z, smoothstep(1.5, 3, px));

            lv = step(p.y - i01 * 0.25, lv);
            c += lv * 1.2 / rep * vec3(1, 1 - i01, i01);
        }
    }

    fragColor = vec4(c, 1);
}
