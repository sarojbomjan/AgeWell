import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String time;
  final String activity;
  final String activityId;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.time,
    required this.activity,
    required this.activityId,
  });

  @override
  Widget build(BuildContext context) {
    // Checking if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkMode
          ? Colors.grey[850]
          : Colors.white, // Darker background for dark mode
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: isDarkMode ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black, // White text for dark mode
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white70
                          : Colors.black54, // Lighter text for dark mode
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteActivity(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to delete the activity from Firebase
  Future<void> _deleteActivity(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('ACTIVITIES')
          .doc(activityId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Activity deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete activity: $e")),
      );
    }
  }
}
