import 'package:flutter/material.dart';

class FeaturedServicesWidget extends StatelessWidget {
  const FeaturedServicesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'Doctor Appointment', 'subtitle': 'Tomorrow at 10 AM'},
      {'title': 'Meal Delivery', 'subtitle': 'New service available'},
      {'title': 'Transportation', 'subtitle': 'Book a ride'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Services',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: services
                .map((service) => _buildServiceCard(
                    context, service['title']!, service['subtitle']!))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
      BuildContext context, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
