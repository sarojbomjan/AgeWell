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

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the system theme is dark
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    final List<Widget> _pages = [
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Spacing and Greeting Widget
                  SizedBox(height: 24),

                  // Upcoming Activities
                  UpcomingActivities(),

                  SizedBox(height: 24),

                  // Today Activities
                  TodayActivities(),

                  SizedBox(height: 24),

                  // Health Metrics
                  HealthMetrics(),
                ],
              ),
            ),
          ),
        ],
      ),
      const Health(),
      Community(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ElderCare'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // Manually toggle dark/light mode if needed
              });
            },
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
          IconButton(
            onPressed: () {
              UserAuthentication.instance.logout();
            },
            icon: const Icon(Icons.logout),
          ),
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
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Emergency button functionality
        },
        icon: const Icon(Icons.emergency),
        label: const Text('SOS'),
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
