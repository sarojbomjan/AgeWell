import 'package:elderly_care/authentication/authentication_exception.dart/login_fauilure.dart';
import 'package:elderly_care/authentication/user_authentication.dart';
import 'package:elderly_care/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // loader
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  // sign user in method
  Future<void> signUserIn(
      String email, String password, BuildContext context) async {
    try {
      // Start loading
      isLoading.value = true;

      // Sign in using Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If successful, navigate to HomePage
      Get.offAll(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordFailure.code(e.code);

      // Show the appropriate error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ex.message)),
      );
    } catch (e) {
      // If an unknown error occurs
      const ex = LoginWithEmailAndPasswordFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ex.message)),
      );
    } finally {
      // End loading
      isLoading.value = false;
    }
  }

  // Google Sign-In
  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;

      await UserAuthentication.instance.signInWithGoogle();
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed. Please try again.");
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // // Facebook Sign-In
  // Future<void> facebookSignIn() async {
  //   try {
  //     isFacebookLoading.value = true;

  //     await UserAuthentication.instance.signInWithFacebook();
  //   } catch (e) {
  //     Get.snackbar("Error", "Facebook Sign-In failed. Please try again.");
  //   } finally {
  //     isFacebookLoading.value = false;
  //   }
  // }
}
