import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/profile_controller.dart';

Future<void> showDeleteConfirmationDialog(
    BuildContext context, ProfileController controller) {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent closing the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("To proceed, please enter your email and password."),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the dialog
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                Get.snackbar('Error', 'Please enter both email and password');
                return;
              }

              try {
                // Re-authenticate the user and proceed with account deletion
                await controller.reAuthenticateAndDeleteAccount(
                    email, password);

                // // First, delete from Firestore
                // final userData =
                //     await controller.getUserData(); // fetch user data
                // if (userData != null) {
                //   await controller.deleteUserFromFirestore(
                //       userData.id!); // Delete from Firestore
                // }

                // // Then, delete from Firebase Authentication
                // await controller
                //     .deleteUserFromAuth(password); // Delete from Authentication
                // // Close the confirmation dialog after successful deletion
                // Get.back();
              } catch (e) {
                print(
                    'Error occurred during re-authentication or account deletion: $e');
                Get.snackbar('Error', 'Failed to authenticate: $e');
              }
            },
            child: const Text('Delete Account'),
          ),
        ],
      );
    },
  );
}
