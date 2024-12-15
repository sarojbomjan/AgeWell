import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/services_booking/doctor_service/current_doctor_booking_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentBookingList extends StatefulWidget {
  const CurrentBookingList({Key? key}) : super(key: key);

  @override
  _CurrentBookingListState createState() => _CurrentBookingListState();
}

class _CurrentBookingListState extends State<CurrentBookingList> {
  List<Map<String, dynamic>> bookings = [];

  Future<void> fetchBookings() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('DoctorBooking')
          .where('userId', isEqualTo: userId)
          .get();

      // Log the number of documents returned
      print('Fetched ${querySnapshot.docs.length} bookings');

      // Clear the previous bookings before adding new ones
      bookings.clear();

      // Loop through each document and add it to the list
      for (var doc in querySnapshot.docs) {
        final bookingData = doc.data() as Map<String, dynamic>;
        print('Fetched Data: $bookingData'); // Log the fetched data

        // Add the booking to the list
        bookings.add(bookingData);
      }

      // Log the current state of bookings
      print('Bookings List: $bookings');

      // Update the UI
      setState(() {});
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                print('Booking $index: ${booking['title']}');
                return CurrentBookingCard(
                  title: booking['title'] ?? 'No Title',
                  doctorName: booking['caregiverName'] ?? 'No Name',
                  date: booking['startDate'] != null
                      ? (booking['startDate'] as Timestamp).toDate().toString()
                      : 'No Date',
                  time: booking['startTime'] ?? 'No Time',
                  bookingID: booking['bookingID'] ?? 'No ID',
                  bookingType: 'doctor',
                );
              },
            ),
    );
  }
}
