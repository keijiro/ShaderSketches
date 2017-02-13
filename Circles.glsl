void main()
{
    float reso = 16.0;

    vec2 p = gl_FragCoord.xy / iResolution.xy;

    vec2 cell = floor(p * reso);
    vec2 center = (cell + 0.5) / reso;

    float t = iGlobalTime + cell.x + cell.y;
    t *= 2.0;

    float l = distance(p, center);
    float r = (0.3 + sin(t) * 0.3) / reso;

    float br1 = smoothstep(0.0, +0.005, l - r);
    float br2 = smoothstep(-0.005, 0.0, r - l);

    vec3 rgb = vec3(br1 * br2 * 8.0);

    gl_FragColor = vec4(rgb, 1);
}