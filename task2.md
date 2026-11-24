# Task 2: Orthogonal Apple-Style "Liquid Glass" Effect Toggle

Inspect the existing theme setup (`Light`, `Dark`, `AMOLED`), settings repository/state management, and core widgets in Hojaty first. Follow Clean Architecture and project extensions.

## Requirements:
1. **Independent Setting (NOT a Theme):**
   - Implement Liquid Glass as a standalone boolean preference (`isLiquidGlassEnabled`) that overlays cleanly on top of Light, Dark, and AMOLED themes.
   - **Platform Defaults:** `true` on iOS (`Platform.isIOS`), `false` on Android (`Platform.isAndroid`).
   - Add a persisted toggle switch in Appearance/General Settings (*"تأثير الزجاج السائل / Liquid Glass"*).

2. **Performance & Rendering Best Practices:**
   - Build a reusable `LiquidGlassContainer` in `core/widgets/`.
   - When disabled: render a standard zero-overhead `Container` / `DecoratedBox` with no `BackdropFilter` or shader allocation.
   - When enabled: use Impeller-friendly `BackdropFilter` (`ImageFilter.blur` with sigma capped at `12.0–16.0`), subtle 1px specular border gradient, and theme-calibrated surface tint opacity. If using a custom `.frag` shader, load and cache the `FragmentProgram` once as a singleton (never inside `build()`).
   - Wrap glass components in `RepaintBoundary` and apply ONLY to elevated chrome surfaces (Bottom Nav Bar, AppBar, Bottom Sheets, Dialogs, Floating Cards)—never inside scrolling list item cells.

Output a brief file-by-file plan first, then implement cleanly and verify zero analyzer warnings.
