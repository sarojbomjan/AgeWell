import "package:elderly_care/authentication/user_authentication.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // textfield controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final address = TextEditingController();

  // register user function
  Future<void> registerUser() async {
    await UserAuthentication.instance.createUserWithEmailAndPassword(
      email.text.trim(),
      password.text.trim(),
      fullName.text.trim(),
      phoneNo.text.trim(),
      address.text.trim(),
    );
  }

  // phone verification
  void phoneAuthentication(String phoneNo) {
    UserAuthentication.instance.phoneAuthentication(phoneNo);
  }
}
