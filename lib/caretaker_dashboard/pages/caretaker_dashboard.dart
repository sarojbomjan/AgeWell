import 'package:elderly_care/caretaker_dashboard/pages/appointment_page.dart';
import 'package:flutter/material.dart';
import 'package:elderly_care/caretaker_dashboard/pages/next_appointment.dart';
import 'package:elderly_care/pages/health/health.dart';
import 'package:elderly_care/caretaker_dashboard/widgets/bottom_nav_bar.dart';

import '../../pages/profile/profile_page.dart';

class CaretakerDashboard extends StatefulWidget {
  const CaretakerDashboard({Key? key}) : super(key: key);

  @override
  State<CaretakerDashboard> createState() => _CaretakerDashboardState();
}

class _CaretakerDashboardState extends State<CaretakerDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardHome(),
    Text('Patients'),
    SchedulePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caretaker Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, Caretaker',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  Icons.calendar_today,
                  'Next Appointment',
                  '10:00 AM',
                  const NextAppointment(),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildInfoCard(
                  context,
                  Icons.favorite,
                  'Health Status',
                  'Stable',
                  const Health(),
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
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon,
                  size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading:
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
