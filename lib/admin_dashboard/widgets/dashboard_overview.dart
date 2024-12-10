import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/latest_update.dart';
import '../widgets/user_role.dart';
import '../../service/mock_data.dart';

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
                value: MockDataService.getTotalUsers().toString(),
                icon: Icons.people,
              ),
              StatCard(
                title: 'Services Booked',
                value: MockDataService.getTotalServicesBooked().toString(),
                icon: Icons.calendar_today,
              ),
              StatCard(
                title: 'Health Alerts',
                value: MockDataService.getHealthAlerts().toString(),
                icon: Icons.health_and_safety,
              ),
              StatCard(
                title: 'Active Locations',
                value: MockDataService.getActiveLocations().toString(),
                icon: Icons.location_on,
              ),
            ],
          ),
          const SizedBox(height: 24),
          LatestUpdates(updates: MockDataService.getLatestUpdates()),
          const SizedBox(height: 24),
          UserTypeBreakdown(userTypes: MockDataService.getUserTypeBreakdown()),
        ],
      ),
    );
  }
}
