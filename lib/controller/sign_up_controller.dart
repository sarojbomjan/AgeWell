import "package:elderly_care/authentication/store_user_details.dart";
import "package:elderly_care/authentication/user_authentication.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../models/user_model.dart";

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // textfield controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final address = TextEditingController();

  // register user function
  void registerUser(String email, String password) {
    UserAuthentication.instance.createUserWithEmailAndPassword(email, password);
  }

  // phone verification
  void phoneAuthentication(String phoneNo) {
    UserAuthentication.instance.phoneAuthentication(phoneNo);
  }

  // store user in Firestore
  Future<void> storeUser() async {
    UserModel user = UserModel(
      fullName: fullName.text.trim(),
      email: email.text.trim(),
      phoneNo: phoneNo.text.trim(),
      address: address.text.trim(),
      role: 'customer',
    );

    await StoreUser.instance.createUser(user);
  }
}
