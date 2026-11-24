class ArabicTextNormalizer {
  static final RegExp _tashkeelRegex = RegExp(
    r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640]',
  );
  static final RegExp _punctuationRegex = RegExp(r'[^\p{L}\p{N}\s]', unicode: true);
  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  /// Normalizes Arabic & Latin text for deterministic offline search:
  /// - Strips Tashkeel & Tatweel
  /// - Maps أ / إ / آ / ٱ -> ا
  /// - Maps ة -> ه
  /// - Maps ى / ئ -> ي, ؤ -> و
  /// - Lowercases Latin text and collapses whitespace
  static String normalize(String input) {
    if (input.isEmpty) return '';
    String out = input.replaceAll(_tashkeelRegex, '');
    out = out
        .replaceAll('ٱ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ئ', 'ي')
        .replaceAll('ؤ', 'و')
        .toLowerCase();
    out = out.replaceAll(_punctuationRegex, ' ');
    return out.replaceAll(_whitespaceRegex, ' ').trim();
  }

  static List<String> tokenize(String input) {
    final norm = normalize(input);
    if (norm.isEmpty) return const [];
    return norm.split(' ');
  }
}
