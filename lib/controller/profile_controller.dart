import 'package:elderly_care/authentication/store_user_details.dart';
import 'package:elderly_care/authentication/user_authentication.dart';
import 'package:elderly_care/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final phoneNo = TextEditingController();
  final address = TextEditingController();

  final _userAuth = Get.put(UserAuthentication());
  final _storeUser = Get.put(StoreUser());

  // get user email and password to fetch user data
  // getUserData() async {
  //   final email = _userAuth.firebaseUser.value?.email;
  //   if (email != null) {
  //     try {
  //       return await _storeUser.getUserDetails(email);
  //     } catch (e) {
  //       Get.snackbar("Error", "Failed to fetch user details: $e");
  //     }
  //   } else {
  //     Get.snackbar("Error", "Please log in to continue.");
  //   }
  // }
  Future<UserModel?> getUserData() async {
    final email = _userAuth.firebaseUser.value?.email;
    if (email != null) {
      try {
        // Assuming _storeUser.getUserDetails returns a UserModel
        final userDetails = await _storeUser.getUserDetails(email);
        return userDetails; // Returning UserModel
      } catch (e) {
        Get.snackbar("Error", "Failed to fetch user details: $e");
      }
    } else {
      Get.snackbar("Error", "Please log in to continue.");
    }
    return null;
  }

  updateRecord(UserModel user) async {
    await _storeUser.updateUserRecord(user);
  }

  // Delete user from Firestore
  deleteUserFromFirestore(String userId) async {
    try {
      // Delete from Firestore
      await _storeUser.deleteUserFromFirestore(userId);

      Get.snackbar("Success", "User deleted from Firestore successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete user from Firestore: $e");
    }
  }

  // Delete user from Firebase Authentication
  deleteUserFromAuth(String password) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently signed in.");
      }

      // Re-authenticate the user before deletion
      final authCredential = EmailAuthProvider.credential(
          email: currentUser.email!, password: password);
      await currentUser.reauthenticateWithCredential(authCredential);

      // Delete user from Firebase Authentication
      await currentUser.delete();
      Get.snackbar("Success", "User deleted from Authentication successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete user from Authentication: $e");
    }
  }

  // Re-authenticate and delete user account
  Future<void> reAuthenticateAndDeleteAccount(
      String email, String password) async {
    final userData = await getUserData();
    final User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      if (currentUser == null) {
        throw Exception("No user is currently signed in.");
      }

      // Re-authenticate the user
      final authCredential =
          EmailAuthProvider.credential(email: email, password: password);
      await currentUser.reauthenticateWithCredential(authCredential);

      // First, delete user from Firestore
      await deleteUserFromFirestore(userData!.id!);

      // Then, delete user from Firebase Authentication
      await deleteUserFromAuth(password);

      // Sign out the user after deletion
      await FirebaseAuth.instance.signOut();

      // Navigate to login screen after deletion
      Get.offAll(() => LoginPage());
      Get.snackbar('Success', 'Your account has been deleted successfully.');
    } catch (e) {
      print('Error deleting account: $e');
      Get.snackbar('Error', 'Failed to delete account: $e');
    }
  }
}
