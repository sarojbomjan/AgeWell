import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/home/home_widgets/health_metric.dart';
import 'package:elderly_care/pages/medical_record/analysis_record/analysis_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HealthMetrics extends StatelessWidget {
  const HealthMetrics({super.key});

  Stream<QuerySnapshot> _getUserAnalysisData(String userId) {
    return FirebaseFirestore.instance
        .collection('Medical_Analysis')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // Health status determination based on value ranges
  String getHealthStatus(String metric, double value) {
    switch (metric) {
      case 'uricAcid':
        return value > 6.0 ? 'High' : 'Normal';
      case 'bloodSugar':
        return value > 125.0 ? 'High' : 'Normal';
      case 'cholesterol':
        return value > 240.0 ? 'High' : 'Normal';
      case 'hba1c':
        return value > 6.0 ? 'High' : 'Normal';
      case 'ogtt':
        return value > 140.0 ? 'High' : 'Normal';
      case 'fastingLevels':
        return value > 100.0 ? 'High' : 'Normal';
      default:
        return 'Normal';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    print("User ID: $userId");

    if (userId == null) {
      return const Center(child: Text('User not authenticated.'));
    }

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<QuerySnapshot>(
      stream: _getUserAnalysisData(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

        var uricAcid = double.tryParse(
                data['uricAcid']?.replaceAll(' mg/dL', '') ?? '0.0') ??
            0.0;
        var bloodSugar = double.tryParse(
                data['bloodSugar']?.replaceAll(' mg/dL', '') ?? '0.0') ??
            0.0;
        var cholesterol = double.tryParse(
                data['cholesterol']?.replaceAll(' mg/dL', '') ?? '0.0') ??
            0.0;
        // var fastingLevels = double.tryParse(
        //         data['fastingLevels']?.replaceAll(' mg/dL', '') ?? '0.0') ??
        //     0.0;
        // var hba1c =
        //     double.tryParse(data['hba1c']?.replaceAll('%', '') ?? '0.0') ?? 0.0;
        // var ogtt =
        //     double.tryParse(data['ogtt']?.replaceAll(' mg/dL', '') ?? '0.0') ??
        //         0.0;

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
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnalysisPage()));
                  },
                  child: Text(
                    'View more',
                    style: TextStyle(
                      color:
                          isDarkMode ? Colors.orange[300] : Colors.orange[400],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  HealthMetric(
                    label: 'URIC ACID',
                    value: '$uricAcid mg/dL',
                    status: getHealthStatus('uricAcid', uricAcid),
                  ),
                  const SizedBox(height: 12),
                  HealthMetric(
                    label: 'BLOOD SUGAR',
                    value: '$bloodSugar mg/dL',
                    status: getHealthStatus('bloodSugar', bloodSugar),
                  ),
                  const SizedBox(height: 12),
                  HealthMetric(
                    label: 'CHOLESTEROL',
                    value: '$cholesterol mg/dL',
                    status: getHealthStatus('cholesterol', cholesterol),
                  ),
                  const SizedBox(height: 12),
                  // HealthMetric(
                  //   label: 'FASTING LEVELS',
                  //   value: '$fastingLevels mg/dL',
                  //   status: getHealthStatus('fastingLevels', fastingLevels),
                  // ),
                  // const SizedBox(height: 12),
                  // HealthMetric(
                  //   label: 'HbA1c',
                  //   value: '$hba1c%',
                  //   status: getHealthStatus('hba1c', hba1c),
                  // ),
                  // const SizedBox(height: 12),
                  // HealthMetric(
                  //   label: 'OGTT',
                  //   value: '$ogtt mg/dL',
                  //   status: getHealthStatus('ogtt', ogtt),
                  // ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
