import 'package:elderly_care/pages/home/home_widgets/emergency_contact.dart';
import 'package:elderly_care/pages/home/home_widgets/social_enagagement_widget.dart';
import 'package:elderly_care/pages/services_booking/booking.dart';
import 'package:elderly_care/service/voice_command.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:elderly_care/pages/community/community.dart';
import 'package:elderly_care/pages/health/health.dart';
import 'package:elderly_care/pages/profile/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'home_widgets/bottom_navigation_widgets.dart';
import 'home_widgets/greeting_widget.dart';
import 'home_widgets/health_metrics.dart';
import 'home_widgets/today_activities.dart';
import 'home_widgets/upcoming_activities.dart';

class HomeScreen extends StatefulWidget {
  // static final GlobalKey<HomeScreenState> homeKey =
  //     GlobalKey<HomeScreenState>();

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String emergencyContact = "";
  final VoiceCommandService _voiceCommandService = VoiceCommandService();
  bool _isListening = false;

  Future<void> onSOSButtonPressed() async {
    if (emergencyContact.isEmpty) {
      // If no emergency contact is set, show the dialog
      showDialog(
        context: context,
        builder: (context) => EmergencyContactDialog(
          onContactSaved: (contact) {
            setState(() {
              // Update emergency contact when saved
              emergencyContact = contact;
            });
            print('SOS button pressed. Emergency contact: $emergencyContact');

            // Show success message after saving contact
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Emergency contact saved successfully.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      );
    } else {
      // If emergency contact is set, launch the dialer
      _launchDialer(emergencyContact);
    }
  }

  @override
  void initState() {
    super.initState();
    _voiceCommandService.setSOSCallback(onSOSButtonPressed);
  }

// Helper method to launch the dialer
  Future<void> _launchDialer(String contact) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: contact);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        Get.snackbar(
          'Error',
          'Could not launch phone dialer.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open phone dialer.',
        snackPosition: SnackPosition.BOTTOM,
      );
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
        // key: HomeScreen.homeKey,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Row(
            children: [
              Image.asset("lib/images/age_well_logo.png",
                  height: 120, width: 70),
              const Text('AgeWell'),
            ],
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
              icon: const Icon(
                LineAwesomeIcons.microphone_solid,
                color: Colors.white,
              ),
              onPressed: () async {
                if (mounted) {
                  setState(() {
                    _isListening = true;
                  });

                  await _voiceCommandService.startListening(context);

                  setState(() {
                    _isListening = false;
                  });
                }
              },
            ),
            if (_isListening) // Show feedback only when listening
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Listening...',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        body: _pages[_currentIndex],
        floatingActionButton: FloatingActionButton.extended(
          onPressed: onSOSButtonPressed, // Call the SOS function
          icon: const Icon(Icons.emergency),
          label: const Text('SOS'),
          backgroundColor: Colors.red,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: onNavTap,
        ),
      );
    });
  }
}
