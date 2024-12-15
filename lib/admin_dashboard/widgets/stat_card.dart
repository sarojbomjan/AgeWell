import 'dart:async';
import 'package:elderly_care/admin_dashboard/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatCard extends StatelessWidget {
  final String title;
  final List<String> collectionNames;
  final IconData icon;
  final String type;

  const StatCard({
    Key? key,
    required this.title,
    required this.collectionNames,
    required this.icon,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                title: title,
                collectionNames: collectionNames,
                icon: icon,
                type: type,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<int>(
            stream: combineCollectionCounts(collectionNames),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data == 0) {
                return Center(
                  child: Text(
                    'No Data Available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              final totalCount = snapshot.data!;

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
                    totalCount.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper function to combine counts from multiple collections
  static Stream<int> combineCollectionCounts(List<String> collectionNames) {
    // Create a stream for each collection
    final streams = collectionNames.map((collection) {
      return FirebaseFirestore.instance
          .collection(collection)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    });

    // Combine all streams manually
    return Stream<int>.multi((controller) {
      final counts = List<int>.filled(collectionNames.length, 0);
      final subscriptions = <StreamSubscription>[];

      for (int i = 0; i < streams.length; i++) {
        subscriptions.add(
          streams.elementAt(i).listen(
            (count) {
              counts[i] = count;
              controller
                  .add(counts.reduce((a, b) => a + b)); // Sum up the counts
            },
            onError: controller.addError,
          ),
        );
      }

      controller.onCancel = () {
        for (final sub in subscriptions) {
          sub.cancel();
        }
      };
    });
  }
}
