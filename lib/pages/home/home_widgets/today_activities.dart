// today_activities.dart
import 'package:elderly_care/pages/home/home_functionalities/add_activity.dart';
import 'package:elderly_care/pages/home/home_widgets/activity.dart';
import 'package:flutter/material.dart';

class TodayActivities extends StatelessWidget {
  const TodayActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today Activities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            TextButton(
              onPressed: () {
                showAddActivityBottomSheet(context);
              },
              child: Text(
                'Add activity',
                style: TextStyle(
                  color: Colors.orange[400],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const ActivityCard(
          icon: Icons.medical_services_outlined,
          iconColor: Colors.green,
          time: '12:00 - 12:30',
          activity: 'Medical checkup with Dr Bayoe',
        ),
        const SizedBox(height: 12),
        const ActivityCard(
          icon: Icons.medication_outlined,
          iconColor: Colors.blue,
          time: '13:00',
          activity: 'Drink Paracetamol 10mg @4 tablets',
        ),
        const SizedBox(height: 12),
        const ActivityCard(
          icon: Icons.directions_run_outlined,
          iconColor: Colors.orange,
          time: '15:10 - 16:00',
          activity: 'Light exercise',
        ),
      ],
    );
  }
}
