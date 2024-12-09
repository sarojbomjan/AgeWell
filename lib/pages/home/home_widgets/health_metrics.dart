// health_metrics.dart
import 'package:elderly_care/pages/home/home_widgets/health_metric.dart';
import 'package:flutter/material.dart';

class HealthMetrics extends StatelessWidget {
  const HealthMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Health Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View more',
                style: TextStyle(
                  color: Colors.orange[400],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: const [
              HealthMetric(
                label: 'URIC ACID',
                value: '5 mg/dL',
                status: 'Good',
              ),
              SizedBox(height: 12),
              HealthMetric(
                label: 'BLOOD SUGAR',
                value: '96 mg/dL',
                status: 'Good',
              ),
              SizedBox(height: 12),
              HealthMetric(
                label: 'CHOLESTEROL',
                value: 'LDL: 90 mg/dL | HDL: 50 mg/dL',
                status: 'Good',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
