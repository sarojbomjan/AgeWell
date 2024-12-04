import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.local_hospital, 'label': 'Doctors'},
      {'icon': Icons.health_and_safety, 'label': 'Nurses'},
      {'icon': Icons.fitness_center, 'label': 'Physiotherapy'},
      {'icon': Icons.article, 'label': 'Health Education'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: categories
              .map((category) => _buildCategoryChip(
                  category['icon'] as IconData, category['label'] as String))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
