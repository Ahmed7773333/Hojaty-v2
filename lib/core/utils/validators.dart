/// Input validators
class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password, {int minLength = 6}) {
    return password.length >= minLength;
  }
  
  static bool hasMinLength(String text, int minLength) {
    return text.length >= minLength;
  }

  static bool isNotEmpty(String? text) {
    return text != null && text.trim().isNotEmpty;
  }

  static bool isValidPhone(String phone) {
    // Basic international phone number regex
    final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    return phoneRegex.hasMatch(phone);
  }

  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
