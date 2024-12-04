class EmailValidator {
  static String? validate(String email) {
    // Check if the email is empty
    if (email.isEmpty) {
      return 'Please enter your email address.';
    }

    // Check if the email is valid
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null; // Valid email
  }
}

class PasswordValidator {
  static String? validate(String password) {
    // Check if the password is empty
    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    // Check if the password is at least 6 characters
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    return null; // Valid password
  }
}

class PhoneValidator {
  static String? validate(String phone) {
    // Check if the phone number is empty
    if (phone.isEmpty) {
      return 'Please enter your phone number.';
    }

    // Check if the phone number contains only numbers
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Please enter a valid phone number with only digits.';
    }

    // Optional: Check if the phone number is long enough (e.g., 10 digits)
    if (phone.length < 10) {
      return 'Phone number must be at least 10 digits long.';
    }

    return null; // Valid phone number
  }
}
