import 'package:flutter/material.dart';

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
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter both email and password'),
                    backgroundColor: Colors.red,
                  ),
                );

                return;
              }

              try {
                await controller.reAuthenticateAndDeleteAccount(
                    email, password);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Account deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please use correct credentials'),
                  ),
                );
              }
            },
            child: const Text('Delete Account'),
          ),
        ],
      );
    },
  );
}
