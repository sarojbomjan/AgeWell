import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHistoryModal extends StatelessWidget {
  final String userId;

  const LocationHistoryModal({Key? key, required this.userId})
      : super(key: key);

  Stream<List<Map<String, dynamic>>> _fetchLocationHistory() {
    return FirebaseFirestore.instance
        .collection('LOCATION')
        .where('userId', isEqualTo: userId)
        .orderBy('lastCheckedIn', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        var location = data['location'];
        var timestamp = data['lastCheckedIn'];
        return {
          'latitude': location['latitude'],
          'longitude': location['longitude'],
          'timestamp': timestamp,
          'address': data['address'] ?? 'Unknown location',
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location History'),
        backgroundColor: const Color(0xFF6750A4),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchLocationHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No location history found.'));
          }

          var locations = snapshot.data!;

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              var location = locations[index];
              var timestamp = (location['timestamp'] as Timestamp).toDate();
              return LocationHistoryCard(
                location: location,
                timestamp: timestamp,
              );
            },
          );
        },
      ),
    );
  }
}

class LocationHistoryCard extends StatelessWidget {
  final Map<String, dynamic> location;
  final DateTime timestamp;

  const LocationHistoryCard({
    Key? key,
    required this.location,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          _showLocationDetails(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF6750A4)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location['address'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d, y - h:mm a').format(timestamp.toLocal()),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) {
          return SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target:
                            LatLng(location['latitude'], location['longitude']),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('location'),
                          position: LatLng(
                              location['latitude'], location['longitude']),
                        ),
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location['address'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Checked in: ${DateFormat('MMM d, y - h:mm a').format(timestamp.toLocal())}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Coordinates:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Latitude: ${location['latitude']}'),
                      Text('Longitude: ${location['longitude']}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
