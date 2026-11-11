#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uImage;
uniform vec3 uTextColor;
uniform vec3 uAccentColor;
uniform vec3 uBgColor;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec4 pixel = texture(uImage, uv);

    // Mushaf PNGs store paper as transparent (alpha = 0) and sample premultiplied.
    // Composite onto pure white paper first so bilinear edge samples around
    // transparent regions don't darken into false ink halos.
    vec3 rgb = clamp(pixel.rgb + vec3(1.0 - pixel.a), 0.0, 1.0);

    float brightness = dot(rgb, vec3(0.299, 0.587, 0.114));
    float maxChannel = max(rgb.r, max(rgb.g, rgb.b));
    float minChannel = min(rgb.r, min(rgb.g, rgb.b));
    float chroma = maxChannel - minChannel;
    float saturation = chroma / max(maxChannel, 0.001);

    // Chroma/saturation separation handles all Qiraat ornament hues (green, gold,
    // blue, peach, lilac) while keeping neutral black/gray ink at 0.
    // Bounding by (1.0 - minChannel) preserves smooth anti-aliased outer edges.
    float edgeSignal = min(saturation, (1.0 - minChannel) * 0.58);
    float accentFactor = smoothstep(0.020, 0.135, edgeSignal);

    // Lower ink entry threshold over ornament interiors (~0.73..0.84 brightness)
    // so ornament fills stay clean while preserving hairline tashkeel on paper.
    float inkStart = mix(0.88, 0.70, accentFactor);
    float inkFactor = smoothstep(inkStart, 0.14, brightness);

    vec3 result = uBgColor;
    result = mix(result, uAccentColor, accentFactor);
    result = mix(result, uTextColor, inkFactor);

    fragColor = vec4(result, 1.0);
}

