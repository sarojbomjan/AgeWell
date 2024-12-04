import 'package:flutter/material.dart';

class HealthOverviewWidget extends StatelessWidget {
  const HealthOverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Overview',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            _buildHealthMetric(Icons.favorite, 'Heart Rate', '72 bpm'),
            _buildHealthMetric(
                Icons.bloodtype, 'Blood Pressure', '120/80 mmHg'),
            _buildHealthMetric(Icons.water_drop, 'Blood Sugar', '100 mg/dL'),
            const SizedBox(height: 16),
            Text(
              'Next Medication: Aspirin at 2:00 PM',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetric(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
