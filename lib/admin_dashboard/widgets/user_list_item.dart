import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../pages/users_page.dart';

class UserListItem extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const UserListItem({
    Key? key,
    required this.userId,
    required this.userData,
  }) : super(key: key);

  // Fetching user details from Firestore
  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('USERS')
          .doc(userId)
          .get();

      return UserModel.fromSnapshot(snapshot);
    } catch (e) {
      print("Error fetching user details: $e");
      return UserModel(
        uid: userId,
        fullName: 'Unknown',
        email: 'No email',
        phoneNo: 'No phone',
        address: 'No address',
        role: 'customer',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: fetchUserDetails(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircularProgressIndicator(),
              title: const Text('Loading...'),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: const Text('Error loading user details'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: const Text('User not found'),
            ),
          );
        }

        final user = snapshot.data!;

        final fullName = user.fullName.isNotEmpty
            ? user.fullName
            : userData['fullName'] ?? 'Unknown';
        final email = user.email.isNotEmpty
            ? user.email
            : userData['email'] ?? 'No email';
        final role =
            user.role.isNotEmpty ? user.role : userData['role'] ?? 'customer';

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                fullName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(fullName),
            subtitle: Text(email),
            trailing: Text(
              role,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsPage(
                    userId: user.uid ?? '',
                    userType: user.role,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
