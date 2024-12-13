import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/home/home_widgets/health_metric.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HealthMetrics extends StatelessWidget {
  const HealthMetrics({super.key});

  // Method to fetch the analysis data from Firestore
  Stream<DocumentSnapshot> _getUserAnalysisData() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    return FirebaseFirestore.instance
        .collection('Medical_Analysis')
        .doc(userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<DocumentSnapshot>(
      stream: _getUserAnalysisData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No data available.'));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        var uricAcid = data['uricAcid'] ?? 'No data';
        var bloodSugar = data['bloodSugar'] ?? 'No data';
        var cholesterol = data['cholesterol'] ?? 'No data';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Health Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? Colors.white70
                        : Colors.black54, // Lighter text in dark mode
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View more',
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.orange[300]
                          : Colors.orange[400], // Subtle change in color
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[850]
                    : Colors.grey[50], // Darker background in dark mode
                borderRadius: BorderRadius.circular(8),
                boxShadow: isDarkMode
                    ? [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2), blurRadius: 6)
                      ] // Subtle shadow in dark mode
                    : [],
              ),
              child: Column(
                children: [
                  HealthMetric(
                    label: 'URIC ACID',
                    value: '$uricAcid ',
                    status: 'Good', // Example: You can also make this dynamic
                  ),
                  const SizedBox(height: 12),
                  HealthMetric(
                    label: 'BLOOD SUGAR',
                    value: '$bloodSugar ',
                    status: 'Good', // Example: You can also make this dynamic
                  ),
                  const SizedBox(height: 12),
                  HealthMetric(
                    label: 'CHOLESTEROL',
                    value: '$cholesterol ',
                    status: 'Good', // Example: You can also make this dynamic
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
