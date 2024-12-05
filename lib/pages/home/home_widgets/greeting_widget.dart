import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/profile_controller.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.instance;

    return Obx(() {
      // If user data is not available, show loading or placeholder
      if (profileController.user.value == null) {
        return const CircularProgressIndicator();
      }

      // Format current date/time dynamically
      final DateFormat dateFormat = DateFormat('EEEE, MMMM d | h:mm a');
      String formattedDate = dateFormat.format(DateTime.now());

      // Otherwise, show the greeting with user's name
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${profileController.user.value?.fullName ?? "Guest"}', // Accessing user's full name
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate, // Dynamically formatted date and time
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    });
  }
}
