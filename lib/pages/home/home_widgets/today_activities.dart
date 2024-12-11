import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/home/home_widgets/activity.dart';
import 'package:flutter/material.dart';

import '../home_functionalities/add_activity.dart';

class TodayActivities extends StatelessWidget {
  const TodayActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today Activities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
            TextButton(
              onPressed: () {
                showAddActivityBottomSheet(context);
              },
              child: Text(
                'Add activity',
                style: TextStyle(
                  color: brightness == Brightness.dark
                      ? Colors.orange[300]
                      : Colors.orange[400],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Remove Expanded here and let the ListView take its own space
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ACTIVITIES')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No activities for today.',
                  style: TextStyle(
                    color: brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              );
            }

            final activities = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true, // Make ListView take up only required space
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ActivityCard(
                    icon: _getCategoryIcon(activity['category']),
                    iconColor:
                        _getCategoryColor(activity['category'], brightness),
                    time: activity['time'] ?? 'No time specified',
                    activity: activity['name'] ?? 'No name provided',
                    activityId: activity.id,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Helper to get category icon based on category type
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Medical':
        return Icons.medical_services_outlined;
      case 'Exercise':
        return Icons.directions_run_outlined;
      case 'Medication':
        return Icons.medication_outlined;
      default:
        return Icons.more_horiz;
    }
  }

  // Helper to get category color based on category type and theme brightness
  Color _getCategoryColor(String category, Brightness brightness) {
    Color color;
    switch (category) {
      case 'Medical':
        color = Colors.green;
        break;
      case 'Exercise':
        color = Colors.orange;
        break;
      case 'Medication':
        color = Colors.blue;
        break;
      default:
        color = Colors.purple;
    }

    // Adjust color brightness based on theme mode
    return brightness == Brightness.dark ? color! : color;
  }
}
