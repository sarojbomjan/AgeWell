import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/add_new_user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final Map<String, int> userTypes = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('USERS') // Replace with your collection name
          .get();

      final Map<String, int> fetchedUserTypes = {};

      for (var doc in querySnapshot.docs) {
        final role = doc['Role'] as String? ?? 'Unknown';
        fetchedUserTypes[role] = (fetchedUserTypes[role] ?? 0) + 1;
      }

      setState(() {
        userTypes.clear();
        userTypes.addAll(fetchedUserTypes);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  userTypes.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: userTypes.entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(entry.key,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                        Text(entry.value.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
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
                  return const AddUserModal(); // No onAddUser required
                },
              ).then((_) =>
                  _fetchUserData()); // Refresh user data after modal closes
            },
            child: const Text('Add New User'),
          ),
        ],
      ),
    );
  }
}
