import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/dashboard_overview.dart';
import 'alerts.dart';
import 'services.dart';
import 'users_page.dart';
import '../../authentication/user_authentication.dart';
import '../../pages/profile/profile_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardOverview(),
    const UsersPage(),
    const ServicesPage(),
    const AlertsPage(),
    const ProfilePage(),
  ];

  final List<String> _titles = [
    'Dashboard Overview',
    'Users Management',
    'Services Management',
    'Alerts',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            onPressed: () {
              UserAuthentication.instance.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
