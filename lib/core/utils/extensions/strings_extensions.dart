/// Safe extension to convert any digits inside a String to Arabic-Indic digits.
/// If you already have a String extension elsewhere, remove this duplicate.
extension ArabicDigitsString on String {
  String toArabicDigits() {
    // ignore: unused_local_variable
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return replaceAllMapped(RegExp(r'\d'), (m) {
      final idx = int.tryParse(m.group(0) ?? '') ?? 0;
      return arabic[idx];
    });
  }
}
