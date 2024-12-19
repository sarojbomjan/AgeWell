import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsPage extends StatelessWidget {
  final String userId;
  final String userType;

  const UserDetailsPage({
    Key? key,
    required this.userId,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userType Details'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("USERS")
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          print('User Data: $userData');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoCard(context, userData),
                const SizedBox(height: 16),
                _buildAdditionalInfo(context, userData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(
      BuildContext context, Map<String, dynamic> userData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData['FullName'] ?? 'N/A',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, userData['Email'] ?? 'N/A'),
            _buildInfoRow(Icons.phone, userData['Phone'] ?? 'N/A'),
            _buildInfoRow(Icons.location_on, userData['Address'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(
      BuildContext context, Map<String, dynamic> userData) {
    switch (userType.toLowerCase()) {
      // case 'customer':
      //   return _buildCustomerInfo(context, userData);
      case 'caregiver':
        return _buildCaregiverInfo(context, userData);
      case 'doctor':
        return _buildDoctorInfo(context, userData);
      default:
        return const SizedBox.shrink();
    }
  }

  // Widget _buildCustomerInfo(
  //     BuildContext context, Map<String, dynamic> userData) {
  //   return Card(
  //     elevation: 2,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Customer Information',
  //             style: Theme.of(context).textTheme.titleLarge,
  //           ),
  //           const SizedBox(height: 8),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCaregiverInfo(
      BuildContext context, Map<String, dynamic> userData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Caregiver Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.work,
                'Experience: ${userData['Experience'] ?? 'N/A'} years'),
            _buildInfoRow(Icons.star, 'Skills: ${userData['Skills'] ?? 'N/A'}'),
            _buildInfoRow(
                Icons.language, 'Languages: ${userData['Languages'] ?? 'N/A'}'),
            _buildInfoRow(Icons.access_time,
                'Work Hours: ${userData['WorkHours'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo(BuildContext context, Map<String, dynamic> userData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.local_hospital,
                'Specialty: ${userData['Specialist'] ?? 'N/A'}'),
            _buildInfoRow(Icons.star,
                'Rating: ${userData['Ratings']?.toString() ?? 'N/A'}'),
            _buildInfoRow(
                Icons.comment, 'Reviews: ${userData['Reviews'] ?? 'N/A'}'),
            _buildInfoRow(Icons.access_time,
                'Availability: ${userData['Availability']?.join(', ') ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
