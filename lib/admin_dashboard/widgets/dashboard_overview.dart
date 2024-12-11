import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/user_role.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Overview',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                title: 'Total Users',
                collectionName: 'USERS',
                icon: Icons.people,
              ),
              // StatCard(
              //   title: 'Services Booked',
              //   collectionName: 'services_booked',
              //   icon: Icons.calendar_today,
              // ),
              // StatCard(
              //   title: 'Health Alerts',
              //   collectionName: 'health_alerts',
              //   icon: Icons.health_and_safety,
              // ),
              // StatCard(
              //   title: 'Active Locations',
              //   collectionName: 'active_locations',
              //   icon: Icons.location_on,
              // ),
            ],
          ),
          const SizedBox(height: 24),
          UserTypeBreakdown(), // Dynamically fetch user types
        ],
      ),
    );
  }
}
