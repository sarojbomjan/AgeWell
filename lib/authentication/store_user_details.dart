import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreUser extends GetxController {
  static StoreUser get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // stores data in firestore database
  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("USERS").doc(user.uid).set(user.toJson());

      Get.snackbar(
        "Success", // Title
        "Registration successful", // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (error) {
      Get.snackbar(
        "Error", // Title
        "Failed to add user: $error", // Error Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      throw Exception("Failed to add user: $error");
    }
  }

  // fetch user details
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("USERS").where("Email", isEqualTo: email).get();

    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    return userData;
  }

  Future<List> getAllUser() async {
    final snapshot = await _db.collection("USERS").get();

    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();

    return userData;
  }

  // update user record
  Future<void> updateUserRecord(UserModel user) async {
    try {
      if (user.uid == null) {
        throw Exception("User ID is null. Cannot update record.");
      }
      await _db.collection("USERS").doc(user.uid).update(user.toJson());

      Get.snackbar(
        "Success", // Title
        "User record updated successfully", // Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (error) {
      Get.snackbar(
        "Error", // Title
        "Failed to update user: $error", // Error Message
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      throw Exception("Failed to update user: $error");
    }
  }

  // Delete the user record from Firestore
  Future<void> deleteUserFromFirestore(String userId) async {
    try {
      await _db.collection("USERS").doc(userId).delete();
      Get.snackbar(
        "Success",
        "User data deleted from Firestore",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Failed to delete user from Firestore: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      throw Exception("Failed to delete user from Firestore: $error");
    }
  }

  //delete user from authentication
  Future<void> deleteUserFromAuth(String password) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently signed in.");
      }

      final email = currentUser.email;

      // Re-authenticate the user to perform deletion
      final authCredential = EmailAuthProvider.credential(
        email: email!,
        password: password,
      );

      await currentUser.reauthenticateWithCredential(authCredential);

      // Now delete the user
      await currentUser.delete();
      Get.snackbar(
        "Success",
        "User account deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      // Print the error and show it in a snackbar
      print('Reauthentication error: $e');
      Get.snackbar(
        "Error",
        "Failed to delete user: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      throw Exception("Failed to delete user from authentication: $e");
    }
  }
}
