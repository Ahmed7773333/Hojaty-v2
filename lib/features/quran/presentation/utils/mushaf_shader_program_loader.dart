import 'dart:ui' as ui;

/// Loads and caches the compiled Mushaf night-mode fragment program.
class MushafShaderProgramLoader {
  MushafShaderProgramLoader._();

  static const String _shaderAssetKey = 'shaders/mushaf_night_mode.frag';
  static Future<ui.FragmentProgram>? _loadFuture;
  static ui.FragmentProgram? _cachedProgram;

  /// Returns the compiled program synchronously once loaded.
  static ui.FragmentProgram? get cachedProgram => _cachedProgram;

  /// Loads the fragment program once and reuses it across Mushaf pages.
  static Future<ui.FragmentProgram> load() {
    if (_cachedProgram != null) {
      return Future<ui.FragmentProgram>.value(_cachedProgram!);
    }
    return _loadFuture ??= ui.FragmentProgram.fromAsset(_shaderAssetKey)
        .then((program) {
          _cachedProgram = program;
          return program;
        })
        .catchError((Object error) {
          _loadFuture = null;
          throw error;
        });
  }
}

