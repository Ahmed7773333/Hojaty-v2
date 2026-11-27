#version 460 core
#include <flutter/runtime_effect.glsl>

// Uniforms 0..1: automatically populated by Impeller ImageFilter.shader
// with the bound backdrop texture's physical pixel dimensions.
uniform vec2 uSize;
uniform float uCornerRadius;     // Physical corner radius in pixels
uniform float uRefraction;       // Edge lensing displacement in physical pixels
uniform float uFrostRadius;      // Single-pass optical diffusion step in pixels
uniform float uVibrancy;         // Rec. 709 chroma multiplier
uniform vec4 uTint;              // Theme tint RGB + alpha
uniform float uSpecularStrength; // Surface sheen & Fresnel rim highlight scale

uniform sampler2D uTexture;      // Backdrop texture bound by Impeller

out vec4 fragColor;

vec2 toBackendUv(vec2 uv) {
    vec2 clamped = clamp(uv, vec2(0.001), vec2(0.999));
#ifdef IMPELLER_TARGET_OPENGLES
    clamped.y = 1.0 - clamped.y;
#endif
    return clamped;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 safeSize = max(uSize, vec2(1.0));
    vec2 uvTopLeft = pos / safeSize;

    // 1. Exact 2D Rounded-Box Signed Distance Field (negative inside, 0 at border)
    vec2 halfSize = safeSize * 0.5;
    vec2 p = pos - halfSize;
    float minHalf = min(halfSize.x, halfSize.y);
    float r = clamp(uCornerRadius, 0.0, minHalf);

    vec2 q = abs(p) - (halfSize - vec2(r));
    float sdf = min(max(q.x, q.y), 0.0) + length(max(q, vec2(0.0))) - r;
    float distToEdge = max(-sdf, 0.0);

    // 2. Smooth C1-continuous outward lens normal along curved meniscus lip
    float bevelWidth = clamp(minHalf * 0.42, 8.0, 34.0);
    float rLens = clamp(max(r, bevelWidth), 0.0, max(minHalf - 0.5, 0.0));
    vec2 qLens = max(abs(p) - (halfSize - vec2(rLens)), vec2(0.0));
    vec2 normal2D = sign(p) * (qLens / (length(qLens) + 0.0001));

    // Convex meniscus slope: steep optical bending near border, flat 0 inside
    float edgeT = 1.0 - smoothstep(0.0, bevelWidth, distToEdge);
    float lensCurve = edgeT * edgeT;
    vec2 refractionUv = normal2D * (lensCurve * uRefraction) / safeSize;
    vec2 baseUv = uvTopLeft - refractionUv;

    // 3. Single-pass 4-tap rotated-grid bilinear optical diffusion (replaces multi-pass blur)
    vec2 stepUv = vec2(uFrostRadius) / safeSize;
    vec3 c0 = texture(uTexture, toBackendUv(baseUv + vec2( 0.75,  0.25) * stepUv)).rgb;
    vec3 c1 = texture(uTexture, toBackendUv(baseUv + vec2(-0.25,  0.75) * stepUv)).rgb;
    vec3 c2 = texture(uTexture, toBackendUv(baseUv + vec2(-0.75, -0.25) * stepUv)).rgb;
    vec3 c3 = texture(uTexture, toBackendUv(baseUv + vec2( 0.25, -0.75) * stepUv)).rgb;
    vec3 diffused = (c0 + c1 + c2 + c3) * 0.25;

    // 4. Subtle chromatic dispersion along steep refractive bezel angles
    vec2 dispUv = refractionUv * 0.22;
    float rDisp = texture(uTexture, toBackendUv(baseUv - dispUv)).r;
    float bDisp = texture(uTexture, toBackendUv(baseUv + dispUv)).b;
    vec3 glassRgb = mix(diffused, vec3(rDisp, diffused.g, bDisp), lensCurve * 0.60);

    // 5. In-register Rec. 709 vibrancy boost (zero extra render passes)
    float luma = dot(glassRgb, vec3(0.2126, 0.7152, 0.0722));
    glassRgb = clamp(mix(vec3(luma), glassRgb, uVibrancy), 0.0, 1.0);

    // 6. Adaptive theme tint + 135-degree liquid sheen + Fresnel rim specular
    vec3 tinted = mix(glassRgb, uTint.rgb, uTint.a);

    float diag = clamp(1.0 - (uvTopLeft.x * 0.55 + uvTopLeft.y * 0.65), 0.0, 1.0);
    float surfaceSheen = diag * diag * 0.08 * uSpecularStrength;

    float rimBand = exp(-distToEdge * 0.34);
    float keyLight = max(0.0, dot(normal2D, vec2(-0.7071, -0.7071)));
    float bounceLight = max(0.0, dot(normal2D, vec2(0.7071, 0.7071))) * 0.32;
    float specular = (keyLight + bounceLight) * rimBand * 0.38 * uSpecularStrength;

    vec3 finalColor = clamp(tinted + vec3(surfaceSheen + specular), 0.0, 1.0);
    fragColor = vec4(finalColor, 1.0);
}
