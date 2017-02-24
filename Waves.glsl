float wave(vec2 coord)
{
    float interval = iResolution.x * 0.03;
    vec2 p = coord / interval;

    float phase1 = dot(p, vec2(0.00, 1.00)) + iGlobalTime * 1.338;
    float phase2 = dot(p, vec2(0.09, 0.11)) + iGlobalTime * 0.566;
    float phase3 = dot(p, vec2(0.08, 0.11)) + iGlobalTime * 0.666;

    float pt = phase1 + sin(phase2) * 3.0;
    pt = abs(fract(pt) - 0.5) * interval * 0.5;

    float lw = 1.2 + sin(phase3) * 0.9;
    return saturate(lw - pt);
}

void main()
{
    gl_FragColor.rgb = vec3(wave(gl_FragCoord.xy));
}