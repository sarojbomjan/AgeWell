import 'package:flutter/material.dart';

class HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final String status;

  const HealthMetric({
    super.key,
    required this.label,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? Colors.white70
                      : Colors.black54, // Lighter text in dark mode
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black87, // Adjust text color for dark mode
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.green[800]
                : Colors.green[50], // Darker green in dark mode
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDarkMode
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2), blurRadius: 6)
                  ] // Subtle shadow in dark mode
                : [],
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: isDarkMode
                    ? Colors.green[400]
                    : Colors.green[400], // Green color stays the same
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? Colors.green[300]
                      : Colors.green[700], // Adjust status color in dark mode
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
