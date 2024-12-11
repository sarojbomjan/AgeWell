import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String collectionName; // Firestore collection to fetch data from
  final IconData icon;

  const StatCard({
    Key? key,
    required this.title,
    required this.collectionName,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('USERS').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Data',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            // Calculate value based on data
            final value = snapshot.data!.docs.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Icon(icon, color: Theme.of(context).primaryColor),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
