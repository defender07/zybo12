class Validators {
  static String? validatePhone(String phone) {
    if (phone.isEmpty) return "Please enter phone number";
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
  }
}
