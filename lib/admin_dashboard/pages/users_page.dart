import 'package:elderly_care/service/mock_data.dart';
import 'package:flutter/material.dart';

import '../components/add_new_user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    final userTypes = MockDataService.getUserTypeBreakdown();

    void _handleAddUser(Map<String, String> userData) {
      // In a real app, you would add the user to your database here
      // For this example, we'll just update the user count
      setState(() {
        userTypes[userData['role']!] = (userTypes[userData['role']] ?? 0) + 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('New ${userData['role']} added: ${userData['name']}')),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Management',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Statistics',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  ...userTypes.entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                Text(entry.value.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddUserModal(onAddUser: _handleAddUser);
                },
              );
            },
            child: const Text('Add New User'),
          ),
        ],
      ),
    );
  }
}
