// activity_card.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String time;
  final String activity;
  final String activityId; // Add the activityId for deletion

  const ActivityCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.time,
    required this.activity,
    required this.activityId, // Pass the activityId
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _deleteActivity(context);
          },
        ),
      ],
    );
  }

  // Function to delete the activity from Firebase
  Future<void> _deleteActivity(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('ACTIVITIES')
          .doc(activityId) // Use the activityId to delete the specific document
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
