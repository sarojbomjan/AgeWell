import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.medical_services, 'label': 'Book Service'},
      {'icon': Icons.phone, 'label': 'Call Emergency'},
      {'icon': Icons.folder_shared, 'label': 'Medical Records'},
      {'icon': Icons.monitor_heart, 'label': 'Health Dashboard'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: actions
              .map((action) => _buildActionButton(
                  action['icon'] as IconData, action['label'] as String))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Implement action functionality
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
