import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserTypeBreakdown extends StatelessWidget {
  final Map<String, int> userTypes;

  const UserTypeBreakdown({Key? key, required this.userTypes})
      : super(key: key);

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
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _createPieChartSections(),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: userTypes.entries.map((entry) {
                return _buildLegendItem(context, entry.key, entry.value);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections() {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return userTypes.entries.map((entry) {
      final index = userTypes.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: '',
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
