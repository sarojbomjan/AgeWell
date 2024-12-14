class LoginWithEmailAndPasswordFailure {
  final String message;

  const LoginWithEmailAndPasswordFailure(
      [this.message = "An unknown error occurred"]);

  factory LoginWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'user-not-found':
        return const LoginWithEmailAndPasswordFailure(
            "No user found for this email. Please check the email.");
      case 'wrong-password':
        return const LoginWithEmailAndPasswordFailure(
            "Incorrect password. Please try again.");
      case 'invalid-email':
        return const LoginWithEmailAndPasswordFailure(
            "The email address is not valid. Please check the email.");
      case 'user-disabled':
        return const LoginWithEmailAndPasswordFailure(
            "This account has been disabled. Please contact support.");
      case 'invalid-credential':
        return const LoginWithEmailAndPasswordFailure(
            "Invalid credentials. Please check your email and password.");
      default:
        return const LoginWithEmailAndPasswordFailure();
    }
  }
}
