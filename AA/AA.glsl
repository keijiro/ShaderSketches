const vec2 textureSize = vec2(128.0);

vec2 QuantizeUV(vec2 uv)
{
    return (floor(uv * textureSize) + 0.5) / textureSize;
}

float Luma(vec3 rgb)
{
    return dot(rgb, vec3(1.0 / 3.0));
}

vec3 AASample(vec2 uv)
{
    vec2 duv = vec2(1.0) / textureSize.xy;
    const float bias = -1000.0;

    vec3 c0 = texture2D(iChannel0, uv).rgb;
    float l0 = Luma(c0);
    float l1 = Luma(texture2D(iChannel0, uv + duv * vec2(-0.5, -0.5), bias).rgb) + 1.0 / 384.0;
    float l2 = Luma(texture2D(iChannel0, uv + duv * vec2(+0.5, -0.5), bias).rgb);
    float l3 = Luma(texture2D(iChannel0, uv + duv * vec2(-0.5, +0.5), bias).rgb);
    float l4 = Luma(texture2D(iChannel0, uv + duv * vec2(+0.5, +0.5), bias).rgb);

    float max_luma = max(max(max(l1, l2), l3), l4);
    float min_luma = min(min(min(l1, l2), l3), l4);
    float contrast = max(l0, max_luma) - min(l0, min_luma);
    if (contrast < max(0.05, 0.125 * max_luma)) return c0;

    vec2 dir1 = normalize(vec2((l3 + l4) - (l1 + l2), (l2 + l4) - (l1 + l3)));
    vec2 dir2 = clamp(dir1 / min(abs(dir1.x), abs(dir1.y)) / 8.0, -2.0, 2.0);

    vec3 c11 = texture2D(iChannel0, uv - duv * dir1 * 0.5, bias).rgb;
    vec3 c12 = texture2D(iChannel0, uv + duv * dir1 * 0.5, bias).rgb;
    vec3 c21 = texture2D(iChannel0, uv - duv * dir2 * 2.0, bias).rgb;
    vec3 c22 = texture2D(iChannel0, uv + duv * dir2 * 2.0, bias).rgb;

    vec3 c1 = (c11 + c12) * 0.5;
    vec3 c2 = (c11 + c12 + c21 + c22) * 0.25;
    float lc2 = Luma(c2);
    return (lc2 > min_luma && lc2 < max_luma) ? c2 : c1;
}

void main()
{
    vec2 uv = QuantizeUV(gl_FragCoord.xy / iResolution.xy);
    vec3 c1 = texture2D(iChannel0, uv).rgb;
    vec3 c2 = AASample(uv);
    float p = saturate(0.5 - cos(iGlobalTime) * 2.0);
    gl_FragColor.rgb = mix(c1, c2, p);
}