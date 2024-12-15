import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/caretaker_dashboard/widgets/to_do_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elderly_care/caretaker_dashboard/widgets/bottom_nav_bar.dart';
import 'package:elderly_care/caretaker_dashboard/pages/appointment_page.dart';
import 'package:elderly_care/caretaker_dashboard/pages/next_appointment.dart';
import 'package:elderly_care/pages/health/health.dart';
import 'package:elderly_care/pages/profile/profile_page.dart';

class CaretakerDashboard extends StatefulWidget {
  const CaretakerDashboard({Key? key}) : super(key: key);

  @override
  State<CaretakerDashboard> createState() => _CaretakerDashboardState();
}

class _CaretakerDashboardState extends State<CaretakerDashboard> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardHome(),
    ScheduleContent(),
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
        title: const Text(
          'Caretaker Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
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
            onTap: () {},
          ),
          const SizedBox(height: 16.0),
          _buildDetailCard(
            context,
            Icons.list,
            'To-Do List',
            'Administer Medication\nPhysical Therapy\nPrepare Meals',
            '/toDoList',
            onTap: () {
              showToDoBottomSheet(context); // Show bottom sheet modal
            },
          ),
          const SizedBox(height: 16.0),
          _buildDetailCard(
            context,
            Icons.phone,
            'Emergency Contacts',
            'Doctor: (555) 123-4567\nFamily: (555) 987-6543',
            '/emergencyContacts',
            onTap: () {},
          ),
          const SizedBox(
            height: 16,
          ),
          _buildActivitiesList()
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

  Widget _buildActivitiesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ACTIVITIES')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching activities'));
        }

        final activities = snapshot.data?.docs ?? [];

        if (activities.isEmpty) {
          return const Center(child: Text('No activities added yet.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(activity['name'] ?? 'No name'),
              subtitle: Text('${activity['time']} - ${activity['category']}'),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    IconData icon,
    String title,
    String content,
    String route, {
    required VoidCallback onTap,
  }) {
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
        onTap: onTap,
      ),
    );
  }
}
