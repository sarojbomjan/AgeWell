import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elderly_care/controller/profile_controller.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:intl/intl.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return FutureBuilder<UserModel?>(
      future: profileController.getUserData(), // Fetch user data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          UserModel userData = snapshot.data!;
          // Format current date/time dynamically
          final DateFormat dateFormat = DateFormat('EEEE, MMMM d | h:mm a');
          String formattedDate = dateFormat.format(DateTime.now());

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("UserId: ${userData.uid}"),
              Text(
                'Hello, ${userData.fullName}', // Display the user's full name
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate, // Display the formatted date/time
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
        } else {
          return const Text('User data not found');
        }
      },
    );
  }
}
