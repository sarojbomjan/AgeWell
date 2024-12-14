import 'package:elderly_care/pages/services_booking/booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:elderly_care/pages/community/community.dart';
import 'package:elderly_care/pages/health/health.dart';
import 'package:elderly_care/pages/profile/profile_page.dart';
import 'package:elderly_care/pages/settings/settings_page.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'home_widgets/bottom_navigation_widgets.dart';
import 'home_widgets/emergency_contact.dart';
import 'home_widgets/greeting_widget.dart';
import 'home_widgets/health_metrics.dart';
import 'home_widgets/social_enagagement_widget.dart';
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

  String emergencyContact = "";
  Future<void> _onSOSButtonPressed() async {
    if (emergencyContact.isEmpty) {
      // Show the emergency contact dialog if the contact is not saved
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return EmergencyContactDialog(
            onContactSaved: (String contact) {
              setState(() {
                emergencyContact = contact; // Update local state
              });
            },
          );
        },
      );
    } else {
      // Ensure the contact is valid before attempting to launch the dialer
      final Uri phoneUri = Uri(scheme: 'tel', path: emergencyContact);
      try {
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(
              phoneUri); // Launch phone dialer with the saved contact
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not launch phone dialer."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to open phone dialer."),
            backgroundColor: Colors.red,
          ),
        );
        debugPrint("Error launching phone dialer: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    final List<Widget> _pages = [
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Greetings
                  GreetingWidget(),
                  SizedBox(height: 24),

                  // Upcoming Activities
                  UpcomingActivities(),

                  SizedBox(height: 24),

                  // Today Activities
                  TodayActivities(),

                  SizedBox(height: 24),

                  // Health Metrics
                  HealthMetrics(),

                  SizedBox(height: 24),

                  // Social Engagement
                  SocialEngagementWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
      const Health(),
      Booking(),
      Community(),
      const ProfilePage(),
    ];

    return Obx(() {
      var currentTheme = themeController.themeData;

      return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Image.asset(
                  'lib/images/age_well_logo.png',
                  width: 70,
                  height: 120,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text('ElderCare'),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                themeController.toggleTheme();
              },
              icon: Icon(
                currentTheme == AppTheme.darkTheme
                    ? LineAwesomeIcons.sun
                    : LineAwesomeIcons.moon,
              ),
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
          onPressed: _onSOSButtonPressed, // Call the SOS function
          icon: const Icon(Icons.emergency),
          label: const Text('SOS'),
          backgroundColor: Colors.red,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      );
    });
  }
}
