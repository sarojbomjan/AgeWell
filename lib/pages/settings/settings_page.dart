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
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // _buildProfileSection(),
          _buildSettingsSection(),
          _buildLanguageSection(),
          _buildEmergencyContactsSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4).withOpacity(0.1),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://placekitten.com/200/200'),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'john.doe@example.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to profile edit page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6750A4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'General Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildSettingsTile(
          title: 'Health Monitoring',
          icon: Icons.health_and_safety,
          onTap: () {
            // Navigate to health monitoring settings
          },
        ),
        _buildSwitchTile(
          title: 'Enable Notifications',
          subtitle: 'Receive health and appointment alerts',
          value: isNotificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              isNotificationsEnabled = value;
            });
          },
        ),
        _buildSwitchTile(
          title: 'Dark Mode',
          subtitle: 'Switch to dark theme',
          value: isDarkMode,
          onChanged: (bool value) {
            setState(() {
              isDarkMode = value;
            });
            // You could use this value to toggle dark mode globally
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Language Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildSettingsTile(
          title: 'Language',
          subtitle: language,
          icon: Icons.language,
          onTap: () {
            _showLanguageDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Emergency',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildSettingsTile(
          title: 'Emergency Contacts',
          icon: Icons.phone,
          onTap: () {
            // Navigate to emergency contacts page
          },
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: Icon(icon, color: const Color(0xFF6750A4)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF6750A4),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English'),
              _buildLanguageOption('Spanish'),
              _buildLanguageOption('French'),
              _buildLanguageOption('German'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String languageOption) {
    return ListTile(
      title: Text(languageOption),
      trailing: language == languageOption
          ? const Icon(Icons.check, color: Color(0xFF6750A4))
          : null,
      onTap: () {
        setState(() {
          language = languageOption;
        });
        Navigator.pop(context);
      },
    );
  }
}
