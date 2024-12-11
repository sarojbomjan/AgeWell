import 'package:elderly_care/pages/services_booking/booking.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:elderly_care/authentication/user_authentication.dart';
import 'package:elderly_care/pages/community/community.dart';
import 'package:elderly_care/pages/health/health.dart';
import 'package:elderly_care/pages/profile/profile_page.dart';
import 'package:elderly_care/pages/settings/settings_page.dart';

import 'home_widgets/bottom_navigation_widgets.dart';
import 'home_widgets/health_metrics.dart';
import 'home_widgets/today_activities.dart';
import 'home_widgets/upcoming_activities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Method to handle navigation tab changes
  void _onNavTap(int index) {
    setState(() {
      print("Current index: $index");
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the system theme is dark
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final List<Widget> _pages = [
      SingleChildScrollView(
        child: Column(
          children: [
            //  const GreetingWidget(),

            const SizedBox(height: 24),

            // Upcoming Activities
            const UpcomingActivities(),

            const SizedBox(height: 24),

            // Today Activities
            const TodayActivities(),

            const SizedBox(height: 24),

            // Health Summary
            const HealthMetrics(),
          ],
        ),
      ),
      const Health(),
      Booking(),
      Community(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ElderCare'),
        actions: [
          // Dark mode toggle
          IconButton(
            onPressed: () {
              setState(() {
                // Toggle between dark and light mode manually here if necessary
              });
            },
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
          // Logout Button
          IconButton(
            onPressed: () {
              UserAuthentication.instance.logout();
            },
            icon: const Icon(Icons.logout),
          ),
          // Settings Button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex], // Display selected page based on index
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Emergency button functionality
        },
        icon: const Icon(Icons.emergency),
        label: const Text('SOS'),
        backgroundColor: Colors.red,
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
