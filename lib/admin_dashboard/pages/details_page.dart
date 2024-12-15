import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/service_list_item.dart';
import '../widgets/stat_card.dart';
import '../widgets/user_list_item.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final List<String> collectionNames;
  final IconData icon;
  final String type;

  const DetailPage({
    Key? key,
    required this.title,
    required this.collectionNames,
    required this.icon,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalUsersCard(context),
            const SizedBox(height: 24),
            Text(
              type == 'user' ? 'User Details' : 'Service Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            type == 'user'
                ? _buildUserList(context)
                : _buildServiceList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalUsersCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<int>(
                    stream: StatCard.combineCollectionCounts(collectionNames),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Text(
                        'Total: ${snapshot.data ?? 0}',
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // User list
  Widget _buildUserList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('USERS').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final userData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final userId = snapshot.data!.docs[index].id;

            // Ensure you correctly access fields from Firestore, e.g.:
            final fullName = userData['fullName'] ??
                'Unknown'; // Default value if field is missing
            final email = userData['email'] ??
                'No email'; // Default value if field is missing
            final phoneNo = userData['phoneNo'] ?? 'No phone number';
            final address = userData['address'] ?? 'No address';

            return UserListItem(
              userId: userId,
              userData: {
                'fullName': fullName,
                'email': email,
                'phoneNo': phoneNo,
                'address': address,
                // Add any other fields that are necessary
              },
            );
          },
        );
      },
    );
  }
}

// Merging Doctor and Caregiver bookings
Widget _buildServiceList(BuildContext context) {
  return FutureBuilder(
    future: Future.wait([
      FirebaseFirestore.instance.collection('DoctorBooking').get(),
      FirebaseFirestore.instance.collection('CaregiverBooking').get(),
    ]),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData ||
          snapshot.data![0].docs.isEmpty && snapshot.data![1].docs.isEmpty) {
        return const Center(child: Text('No bookings found.'));
      }

      final doctorBookings = snapshot.data![0].docs;
      final caregiverBookings = snapshot.data![1].docs;

      // Combine both lists (Doctor and Caregiver bookings)
      final allBookings = [
        ...doctorBookings,
        ...caregiverBookings,
      ];

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allBookings.length,
        itemBuilder: (context, index) {
          final serviceData = allBookings[index].data() as Map<String, dynamic>;
          final bookingId = allBookings[index].id;

          final serviceType =
              serviceData.containsKey('doctorName') ? 'doctor' : 'caregiver';

          return ServiceListItem(
            bookingId: bookingId,
            serviceData: serviceData,
            serviceType: serviceType,
          );
        },
      );
    },
  );
}
