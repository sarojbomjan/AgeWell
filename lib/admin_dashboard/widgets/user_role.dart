import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserTypeBreakdown extends StatelessWidget {
  const UserTypeBreakdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Type Breakdown',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('USERS').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('Error fetching user types'),
                  );
                }

                // Count user types
                final userDocs = snapshot.data!.docs;
                final Map<String, int> userTypeCounts = {};
                for (var doc in userDocs) {
                  final userType = doc['Role'] ?? 'Unknown';
                  userTypeCounts[userType] =
                      (userTypeCounts[userType] ?? 0) + 1;
                }

                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: _createPieChartSections(userTypeCounts),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: userTypeCounts.entries.map((entry) {
                        return _buildLegendItem(
                            context, entry.key, entry.value);
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(
      Map<String, int> userTypeCounts) {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.cyan,
    ];

    return userTypeCounts.entries.map((entry) {
      final index = userTypeCounts.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: entry.value.toString(),
        radius: 50,
      );
    }).toList();
  }

  Widget _buildLegendItem(BuildContext context, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value.toString(), style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
