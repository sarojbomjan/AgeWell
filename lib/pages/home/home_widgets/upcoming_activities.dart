import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingActivities extends StatelessWidget {
  const UpcomingActivities({super.key});

  @override
  Widget build(BuildContext context) {
    // Checking if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Activities',
          style: isDarkMode
              ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white, // White color for dark mode
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('CaregiverBooking')
              .where('userID',
                  isEqualTo: currentUser?.uid) // Ensure correct field name
              .orderBy('startDate',
                  descending: false) // Sort by timestamp directly
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No upcoming activities.',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              );
            }

            final activities = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final activityTime =
                    activity['startTime'] ?? 'No time specified';
                final activityTitle =
                    activity['specialNotes'] ?? 'No description provided';

                // Access the timestamp directly from the Firestore document
                final appointmentDate = activity['startDate'] as Timestamp?;
                final formattedDate = appointmentDate != null
                    ? DateFormat("yyyy-MM-dd").format(appointmentDate.toDate())
                    : 'No date specified';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: isDarkMode
                              ? Colors.green[400]!
                              : Colors.green[300]!,
                          width: 4,
                        ),
                      ),
                      color: isDarkMode
                          ? Colors.grey[900]
                          : Colors.grey[50], // Dark background in dark mode
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isDarkMode
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 6,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate, // Use the formatted timestamp
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activityTime,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activityTitle,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
