import 'package:elderly_care/caretaker_dashboard/pages/caretaker_dashboard.dart';
import 'package:elderly_care/pages/profile/profile_page.dart';
import 'package:elderly_care/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CaretakerDashboard()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            break;
          case 2:
            // Navigate to Settings page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
            break;
        }
      },
    );
  }
}
