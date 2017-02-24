const vec2 textureSize = vec2(128.0);

vec2 QuantizeUV(vec2 uv)
{
    return (floor(uv * textureSize) + 0.5) / textureSize;
}

float Luma(vec3 rgb)
{
    return dot(rgb, vec3(0.2126, 0.7152, 0.0722));
}

vec3 SampleTexture(vec2 uv)
{
    return texture2D(iChannel0, uv, -1000.0).rgb;
}

vec3 AASample(vec2 uv, bool force2tap, bool mask)
{
    vec2 duv = 1.0 / textureSize.xy;

    vec3 c0 = SampleTexture(uv);

    float l0 = Luma(c0);
    float l1 = Luma(SampleTexture(uv + duv * vec2(-0.5, -0.5))) + 1.0 / 384.0;
    float l2 = Luma(SampleTexture(uv + duv * vec2(+0.5, -0.5)));
    float l3 = Luma(SampleTexture(uv + duv * vec2(-0.5, +0.5)));
    float l4 = Luma(SampleTexture(uv + duv * vec2(+0.5, +0.5)));

    float l_max = max(max(max(l1, l2), l3), l4);
    float l_min = min(min(min(l1, l2), l3), l4);
    float contrast = max(l0, l_max) - min(l0, l_min);
    if (contrast < max(0.05, 0.125 * l_max)) return c0;

    if (mask) return vec3(1.0, 0.0, 0.0);

    vec2 dir1 = normalize(vec2((l3 + l4) - (l1 + l2), (l2 + l4) - (l1 + l3)));
    vec2 dir2 = clamp(dir1 / (min(abs(dir1.x), abs(dir1.y)) * 8.0), -2.0, 2.0);

    vec3 c1a = SampleTexture(uv - duv * dir1 * 0.5);
    vec3 c1b = SampleTexture(uv + duv * dir1 * 0.5);
    vec3 c2a = SampleTexture(uv - duv * dir2 * 2.0);
    vec3 c2b = SampleTexture(uv + duv * dir2 * 2.0);

    vec3 c_2tap = (c1a + c1b) * 0.5;
    vec3 c_4tap = (c1a + c1b + c2a + c2b) * 0.25;
    float l_4tap = Luma(c_4tap);
    return (l_4tap < l_min || l_max < l_4tap || force2tap) ? c_2tap : c_4tap;
}

void main()
{
    vec2 uv = QuantizeUV(gl_FragCoord.xy / iResolution.xy * 2.0);

    if (uv.y < 1.0)
        if (uv.x < 1.0)
            gl_FragColor.rgb = AASample(fract(uv), true, false);
        else
            gl_FragColor.rgb = AASample(fract(uv), false, false);
    else
        if (uv.x < 1.0)
            gl_FragColor.rgb = SampleTexture(fract(uv));
        else
            gl_FragColor.rgb = AASample(fract(uv), false, true);
}