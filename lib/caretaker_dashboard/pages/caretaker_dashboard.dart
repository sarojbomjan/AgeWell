import 'package:elderly_care/caretaker_dashboard/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class CaretakerDashboard extends StatefulWidget {
  const CaretakerDashboard({super.key});

  @override
  State<CaretakerDashboard> createState() => _CaretakerDashboardState();
}

class _CaretakerDashboardState extends State<CaretakerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caretaker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    Icons.calendar_today,
                    'Next Appointment',
                    '10:00 AM',
                    '/nextAppointment',
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    Icons.favorite,
                    'Health Status',
                    'Stable',
                    '/healthStatus',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildDetailCard(
              context,
              Icons.notes,
              'Recent Notes',
              'Patient had a good night\'s sleep. No significant changes.',
              '/recentNotes',
            ),
            const SizedBox(height: 16.0),
            _buildDetailCard(
              context,
              Icons.list,
              'To-Do List',
              'Administer Medication\nPhysical Therapy\nPrepare Meals',
              '/toDoList',
            ),
            const SizedBox(height: 16.0),
            _buildDetailCard(
              context,
              Icons.phone,
              'Emergency Contacts',
              'Doctor: (555) 123-4567\nFamily: (555) 987-6543',
              '/emergencyContacts',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildInfoCard(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      String route,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.1), // Set background color inside
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Card(
          color: Colors.lightBlueAccent.withOpacity(0.1),
          elevation: 0, // Remove card's default shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: Colors.red), // Icon color
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Text color for title
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.blueGrey, // Text color for subtitle
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      BuildContext context,
      IconData icon,
      String title,
      String content,
      String route,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Icon(icon, size: 40),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(content),
        ),
      ),
    );
  }
}
