import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Settings
            ListTile(
              title: const Text('Edit Profile'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                // Navigate to profile edit page
              },
            ),
            const Divider(),

            // Health Settings
            ListTile(
              title: const Text('Health Monitoring'),
              leading: const Icon(Icons.health_and_safety),
              onTap: () {
                // Navigate to health monitoring settings
              },
            ),
            const Divider(),

            // Notification Settings
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive health and appointment alerts'),
              value: isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),
            const Divider(),

            // Theme Settings
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch to dark theme'),
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                });
                // You could use this value to toggle dark mode globally
              },
            ),
            const Divider(),

            // Language Settings
            ListTile(
              title: const Text('Language'),
              subtitle: Text(language),
              leading: const Icon(Icons.language),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            const Divider(),

            // Emergency Contacts
            ListTile(
              title: const Text('Emergency Contacts'),
              leading: const Icon(Icons.phone),
              onTap: () {
                // Navigate to emergency contacts page
              },
            ),
          ],
        ),
      ),
    );
  }

  // Show language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    language = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Spanish'),
                onTap: () {
                  setState(() {
                    language = 'Spanish';
                  });
                  Navigator.pop(context);
                },
              ),
              // Add more languages as needed
            ],
          ),
        );
      },
    );
  }
}
