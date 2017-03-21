#define MONOCHROME 1

vec3 circle(vec2 coord, float bias)
{
    float repeat = sin(iGlobalTime * 0.4) * 10.0 + 30.0;

    float interval = iResolution.x / repeat;
    vec2 center = iResolution.xy * 0.5;

    float dist1 = distance(coord, center);
    float num = max(floor(dist1 / interval + 0.5) + bias, 1.0);
    float radius = num * interval;

    float phase1 = iGlobalTime * 3.0 + radius * 0.04;
    float phase2 = phase1 * 1.3426;
    vec2 offs = vec2(sin(phase1), cos(phase2)) * interval * 0.5;
    float dist2 = distance(coord, center + offs);

    float width = interval * 0.33;
    float c = clamp(width * 0.5 - abs(radius - dist2), 0.0, 1.0);

#if MONOCHROME
    return vec3(1, 1, 1) * c;
#else
    float c_r = 0.7 + 0.2 * sin(phase1 * 0.12);
    float c_g = 0.5 + 0.2 * sin(phase1 * 0.34);
    float c_b = 0.3 + 0.2 * sin(phase1 * 0.176);
    return vec3(c_r, c_g, c_b) * c;
#endif
}

void main()
{
    vec2 p = gl_FragCoord.xy;
    vec3 c1 = circle(p, -1.0);
    vec3 c2 = circle(p,  0.0);
    vec3 c3 = circle(p,  1.0);
    gl_FragColor = vec4(max(max(c1, c2), c3), 1);
}