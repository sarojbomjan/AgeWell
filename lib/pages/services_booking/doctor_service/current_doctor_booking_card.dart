import 'package:flutter/material.dart';
import '../booking_details_page.dart';

class CurrentBookingCard extends StatelessWidget {
  final String title;
  final String doctorName;
  final String date;
  final String time;
  final String bookingType;
  final String bookingID; // Added bookingID

  const CurrentBookingCard({
    required this.title,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.bookingType,
    required this.bookingID, // Added bookingID to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  doctorName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsPage(
                      bookingID: bookingID, // Pass the bookingID here
                      bookingType: bookingType, // Pass bookingType
                    ),
                  ),
                );
              },
              child: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
