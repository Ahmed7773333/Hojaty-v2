import 'dart:developer' as dev;

class GeminiKeyPool {
  static final GeminiKeyPool _instance = GeminiKeyPool._internal();
  factory GeminiKeyPool() => _instance;

  GeminiKeyPool._internal() {
    _initFromEnvironment();
  }

  static const String _rawKeys = String.fromEnvironment('GEMINI_KEYS');
  final List<String> _keys = [];
  final Map<String, DateTime> _cooldowns = {};
  int _currentIndex = 0;

  void _initFromEnvironment() {
    if (_rawKeys.isNotEmpty) {
      final parts = _rawKeys.split(',');
      for (final part in parts) {
        final trimmed = part.trim();
        if (trimmed.isNotEmpty) {
          _keys.add(trimmed);
        }
      }
    }
  }

  /// Override or initialize keys programmatically (useful for tests or custom loaders).
  void setKeys(List<String> keys) {
    _keys.clear();
    for (final k in keys) {
      final trimmed = k.trim();
      if (trimmed.isNotEmpty) {
        _keys.add(trimmed);
      }
    }
    _cooldowns.clear();
    _currentIndex = 0;
  }

  int get totalKeys => _keys.length;

  bool get hasKeys => _keys.isNotEmpty;

  /// Mark a key as being on cooldown for [duration] (default: 62 seconds).
  void markCooldown(String key, {Duration duration = const Duration(seconds: 62)}) {
    _cooldowns[key] = DateTime.now().add(duration);
    dev.log('GeminiKeyPool: Key ending in ...${key.length >= 6 ? key.substring(key.length - 6) : key} placed on cooldown for ${duration.inSeconds}s');
  }

  /// Checks if a key is currently free from cooldown.
  bool isKeyAvailable(String key) {
    final expiry = _cooldowns[key];
    if (expiry == null) return true;
    if (DateTime.now().isAfter(expiry)) {
      _cooldowns.remove(key);
      return true;
    }
    return false;
  }

  /// Clear all active cooldowns.
  void resetCooldowns() {
    _cooldowns.clear();
    _currentIndex = 0;
  }

  /// Get the next available key via round-robin.
  /// If all keys are currently on cooldown, falls back to the key that expires earliest.
  String? getNextKey() {
    if (_keys.isEmpty) return null;

    final count = _keys.length;
    for (int i = 0; i < count; i++) {
      final candidateIndex = (_currentIndex + i) % count;
      final candidateKey = _keys[candidateIndex];
      if (isKeyAvailable(candidateKey)) {
        _currentIndex = (candidateIndex + 1) % count;
        return candidateKey;
      }
    }

    // All keys are currently on cooldown. Find the key that expires earliest.
    String earliestKey = _keys[_currentIndex % count];
    DateTime earliestExpiry = _cooldowns[earliestKey] ?? DateTime.now();

    for (final key in _keys) {
      final expiry = _cooldowns[key];
      if (expiry != null && expiry.isBefore(earliestExpiry)) {
        earliestKey = key;
        earliestExpiry = expiry;
      }
    }

    _currentIndex = (_keys.indexOf(earliestKey) + 1) % count;
    return earliestKey;
  }
}
