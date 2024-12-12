import 'package:elderly_care/pages/home/home_widgets/health_metric.dart';
import 'package:flutter/material.dart';

class HealthMetrics extends StatelessWidget {
  const HealthMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
