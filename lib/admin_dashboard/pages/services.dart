import 'package:elderly_care/service/mock_data.dart';
import 'package:elderly_care/theme/admin_theme.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services Management',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services Overview',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.calendar_today,
                        color: AdminTheme.primaryColor),
                    title: const Text('Total Services Booked'),
                    trailing: Text(
                      MockDataService.getTotalServicesBooked().toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  // Add more service-related statistics here
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement add service functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Add Service functionality not implemented yet')),
              );
            },
            child: const Text('Add New Service'),
          ),
        ],
      ),
    );
  }
}
