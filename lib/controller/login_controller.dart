import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/admin_dashboard/pages/admin_dashboard.dart';
import 'package:elderly_care/authentication/authentication_exception.dart/login_fauilure.dart';
import 'package:elderly_care/authentication/user_authentication.dart';
import 'package:elderly_care/pages/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // loader
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  Future<void> signUserIn(
      String email, String password, BuildContext context) async {
    try {
      // Start loading
      isLoading.value = true;

      // Sign in using Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user role from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('USERS')
          .doc(userCredential.user!.uid)
          .get();

      final role = userDoc['Role'];

      // Navigate to the appropriate screen based on the role
      if (role == 'admin') {
        Get.offAll(() => const AdminDashboard());
      } else if (role == 'customer') {
        Get.offAll(() => HomeScreen());
      } else {
        throw Exception('Unknown user role');
      }
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordFailure.code(e.code);

      // Show the appropriate error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ex.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // If an unknown error occurs
      const ex = LoginWithEmailAndPasswordFailure();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ex.message),
          backgroundColor: Colors.red,
        ),
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
