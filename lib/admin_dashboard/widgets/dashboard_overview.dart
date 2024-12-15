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
                collectionNames: ['USERS'],
                icon: Icons.people,
                type: "user",
              ),
              StatCard(
                title: 'Services Booked',
                collectionNames: ['DoctorBooking', 'CaregiverBooking'],
                icon: Icons.calendar_today,
                type: 'services',
              ),
            ],
          ),
          const SizedBox(height: 24),
          UserTypeBreakdown(),
        ],
      ),
    );
  }
}
