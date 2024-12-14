import 'package:flutter/material.dart';

class OldAgeHomePage extends StatelessWidget {
  const OldAgeHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Lalitpur', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: const [
            Icon(Icons.location_on, color: Colors.white),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildOldAgeHomeCard(
                name: 'Old Age Home A',
                location: 'Imadol, Lalitpur',
                distance: '3.6 km',
                price: '1000/hr',
                availability: 'Available 10 Slots Today',
                rating: 4.2,
              ),
              const SizedBox(height: 16.0),
              _buildOldAgeHomeCard(
                name: 'Old Age Home B',
                location: 'Imadol, Lalitpur',
                distance: '2.3 km',
                price: '1200/hr',
                availability: 'Last 2 Slots',
                rating: 4.2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOldAgeHomeCard({
    required String name,
    required String location,
    required String distance,
    required String price,
    required String availability,
    required double rating,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://via.placeholder.com/80', // Replace with actual image URL
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(location, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(rating.toString(),
                              style: const TextStyle(fontSize: 14.0)),
                          const SizedBox(width: 4.0),
                          const Text('(40)',
                              style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                        ],
                      ),
                      Text(price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0)),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    availability,
                    style: TextStyle(
                      color: availability.contains('Last')
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
