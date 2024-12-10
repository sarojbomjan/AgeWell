import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LatestUpdates extends StatelessWidget {
  final List<Map<String, dynamic>> updates;

  const LatestUpdates({Key? key, required this.updates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Updates',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: updates.length,
              itemBuilder: (context, index) {
                final update = updates[index];
                return ListTile(
                  title: Text(update['title']),
                  subtitle: Text(update['description']),
                  trailing: Text(
                    DateFormat('MMM d, y').format(update['date']),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
