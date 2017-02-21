void main()
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    uv = (floor(uv * 128.0) + 0.5) / 128.0;
    gl_FragColor = texture2D(iChannel0, uv);
}