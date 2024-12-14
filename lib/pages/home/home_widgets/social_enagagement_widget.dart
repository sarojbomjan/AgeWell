import 'package:elderly_care/pages/community/video_features/video.dart';
import 'package:flutter/material.dart';

class SocialEngagementWidget extends StatelessWidget {
  const SocialEngagementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Social Engagement',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Join Community Group'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Video()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Upcoming Events'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement events navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}
