import 'package:flutter/material.dart';

class UpcomingActivities extends StatelessWidget {
  const UpcomingActivities({super.key});

  @override
  Widget build(BuildContext context) {
    // Checking if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isDarkMode ? Colors.green[400]! : Colors.green[300]!,
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
                '12:00 - 12:30',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black, // White text in dark mode
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Medical checkup with Dr Bayoe',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDarkMode
                          ? Colors.white70
                          : Colors.black54, // Lighter text for dark mode
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
