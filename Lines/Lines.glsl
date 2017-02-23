float texture(vec2 uv, float t)
{
    uv *= mix(0.5, 0.35, t);
    uv += mix(vec2(0.05, 0.2), vec2(0.4, 0.4), t);
    return dot(texture2D(iChannel0, uv).rgb, vec3(0.3333));
}

float line(vec2 coord)
{
    float interval = iResolution.x * 0.03;
    vec2 dir = normalize(vec2(1.0, 3.0));

    float rel = fract(dot(coord, dir) / interval) - 0.5;
    vec2 uv = (coord - dir * rel * interval) / iResolution.xy;

    float phase = fract(iGlobalTime * 0.2);
    float c2w = (1.0 - cos(phase * 3.142 * 2.0)) * 3.0;
    float width = 0.71 + texture(uv, phase) * c2w;

    return saturate(width - abs(rel * interval));
}

void main()
{
    gl_FragColor = vec4(line(gl_FragCoord.xy));
}