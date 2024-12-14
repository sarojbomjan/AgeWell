import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/home/home_widgets/activity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../home_functionalities/add_activity.dart';

class TodayActivities extends StatelessWidget {
  const TodayActivities({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> scheduleActivityReminder(
        String activityId, String activityTime) async {
      final format = DateFormat("h:mm a");
      DateTime activityDateTime = format.parse(activityTime);

      // Get today's date to combine with the activity time
      final now = DateTime.now();
      final todayDate = DateTime(now.year, now.month, now.day);
      activityDateTime = todayDate.add(Duration(
          hours: activityDateTime.hour, minutes: activityDateTime.minute));

      // Calculate the time difference
      final timeDifference = activityDateTime.difference(now);

      // Check if the activity is within 10 minutes of starting
      if (timeDifference.inMinutes <= 10 && timeDifference.inMinutes >= 0) {
        // Fetch the activity title from Firestore
        DocumentSnapshot activityDoc = await FirebaseFirestore.instance
            .collection('ACTIVITIES')
            .doc(activityId) // Using activityId to get the specific activity
            .get();

        if (activityDoc.exists) {
          String activityTitle = activityDoc['name'];

          // Create the NotificationContent with the activity title
          NotificationContent notificationContent = NotificationContent(
            id: activityId.hashCode, // Unique ID for the notification
            channelKey: 'basic_channel',
            title: 'Activity Reminder',
            body: 'Your activity "$activityTitle" is about to start!',
            notificationLayout: NotificationLayout.Default,
          );

          // Create the notification with the content
          await AwesomeNotifications().createNotification(
            content: notificationContent,
          );
        } else {
          print("Activity not found in Firestore.");
        }
      } else {
        print("Activity is not within 10 minutes.");
      }
    }

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
              return const Center(child: CircularProgressIndicator());
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

            // Schedule notifications for activities near their time
            for (var activity in activities) {
              final activityTime = activity['time'];
              if (activityTime != null) {
                scheduleActivityReminder(activity.id, activityTime);
              }
            }

            return ListView.builder(
              shrinkWrap: true,
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
        )
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
    return brightness == Brightness.dark ? color : color;
  }
}
