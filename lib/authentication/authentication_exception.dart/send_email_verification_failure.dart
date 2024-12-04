class SendEmailVerificationFailure {
  final String message;

  const SendEmailVerificationFailure(
      [this.message = "An unknown error occurred."]);

  factory SendEmailVerificationFailure.code(String code) {
    switch (code) {
      case "user-not-found":
        return SendEmailVerificationFailure(
            "No user found for the given email.");
      case "invalid-email":
        return SendEmailVerificationFailure("The email address is invalid.");
      case "too-many-requests":
        return SendEmailVerificationFailure(
            "Too many requests. Please try again later.");
      case "network-request-failed":
        return SendEmailVerificationFailure(
            "A network error occurred. Please check your connection.");
      default:
        return SendEmailVerificationFailure();
    }
  }
}
