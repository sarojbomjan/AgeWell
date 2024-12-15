import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../booking_details_page.dart';

class CaregiverBookingCard extends StatelessWidget {
  final String caregiverName;
  final DateTime startDate;
  final String startTime;
  final DateTime endDate;
  final String endTime;
  final String location;
  final String bookingID;
  const CaregiverBookingCard({
    required this.caregiverName,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.location,
    required this.bookingID,
  });
  String _formatDate(DateTime date) {
    return DateFormat('d MMM, yyyy')
        .format(date); // Format date as '14 Dec, 2024'
  }

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
            // Caregiver name
            Text(
              "Booking information",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            // Start and End Date
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  ' ${_formatDate(startDate)} to ${_formatDate(endDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Start and End Time
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '$startTime to $endTime',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 5),
            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  location,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // View Details Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsPage(
                      bookingID:
                          bookingID, // Pass the unique booking ID from Firestore here
                      bookingType: 'caregiver',
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text('View Details'),
              ),
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
