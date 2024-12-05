import 'package:elderly_care/authentication/user_authentication.dart';
// import 'package:elderly_care/pages/community/community.dart';
import 'package:elderly_care/pages/health/health.dart';
import 'package:elderly_care/pages/googlemap/location_sharing.dart';
import 'package:elderly_care/pages/profile/profile_page.dart';
import 'package:elderly_care/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'home_widgets/bottom_navigation_widgets.dart';
import 'home_widgets/categories_widget.dart';
import 'home_widgets/featured_services_widget.dart';
import 'home_widgets/greeting_widget.dart';
import 'home_widgets/health_overview_widget.dart';
import 'home_widgets/quick_action_widget.dart';
import 'home_widgets/search_bar_widget.dart';
import 'home_widgets/social_enagagement_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            GreetingWidget(),
            SizedBox(height: 24),
            SearchBarWidget(),
            SizedBox(height: 24),
            QuickActionsWidget(),
            SizedBox(height: 24),
            HealthOverviewWidget(),
            SizedBox(height: 24),
            FeaturedServicesWidget(),
            SizedBox(height: 24),
            CategoriesWidget(),
            SizedBox(height: 24),
            SocialEngagementWidget(),
          ],
        ),
      ),
      const Health(),
      // const Community(),
      const LocationSharingScreen(),
      const ProfilePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElderCare'),
        actions: [
          IconButton(
              onPressed: () {},
              icon:
                  Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
          IconButton(
              onPressed: () {
                UserAuthentication.instance.logout();
              },
              icon: const Icon(Icons.logout)),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
