import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/services_booking/caretaker_service/caretaker_page.dart';
import 'package:elderly_care/pages/services_booking/doctor_service/current_doctor_booking_card.dart';
import 'package:elderly_care/pages/services_booking/doctor_service/doctor_page.dart';
import 'package:elderly_care/pages/services_booking/old_age_home_service/old_age_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../models/caregiver_booking_model.dart';
import '../../models/doctor_booking_mode.dart';
import 'caretaker_service/caregiver_booking_card.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Future<BookingModel>? _currentBooking;
  Future<CaregiverBookingModel>? _currentCaregiverBooking;

  // Fetch the current doctor booking for the user
  Future<BookingModel> _fetchCurrentBooking() async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('DoctorBooking')
        .where('userId', isEqualTo: currentUserId) // Filter by userId
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      return BookingModel.fromFirestore(doc);
    } else {
      throw Exception('Doctor booking not found');
    }
  }

  // Fetch the current caregiver booking for the user
  Future<CaregiverBookingModel> _fetchCaregiverBooking() async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('CaregiverBooking')
        .where('userID', isEqualTo: currentUserId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      return CaregiverBookingModel.fromFirestore(doc);
    } else {
      throw Exception('Caregiver booking not found');
    }
  }

  @override
  void initState() {
    super.initState();
    _currentBooking = _fetchCurrentBooking();
    _currentCaregiverBooking = _fetchCaregiverBooking();
  }

  void _refreshBookings() {
    setState(() {
      _currentBooking = _fetchCurrentBooking();
      _currentCaregiverBooking = _fetchCaregiverBooking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Booking'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for facilities',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Categories
            const Text(
              'All Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Category Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorPage(),
                        ),
                      ).then((_) {
                        // Refresh data when coming back to Booking page
                        _refreshBookings();
                      });
                    },
                    child: const CategoryCard(
                      title: 'Doctor',
                      subtitle: 'Consult',
                      icon: Icons.person,
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CaretakerPage(),
                        ),
                      ).then((_) {
                        _refreshBookings();
                      });
                    },
                    child: const CategoryCard(
                      title: 'Caretaker',
                      subtitle: 'Hire',
                      icon: Icons.person,
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OldAgeHomePage()),
                      );
                    },
                    child: const CategoryCard(
                      title: 'Old Age Home',
                      subtitle: 'Join',
                      icon: Icons.home,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Current Booking - Doctor Booking
            const Text(
              'Current Doctor Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<BookingModel>(
                future: _currentBooking,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No doctor booking found');
                  } else {
                    final booking = snapshot.data!;
                    return CurrentBookingCard(
                      title: booking.description,
                      doctorName: booking.doctorName,
                      date: booking.appointmentDate,
                      time: booking.appointmentTime,
                      bookingType: 'doctor',
                      bookingID: booking.bookingID,
                    );
                  }
                }),

            const SizedBox(height: 20),

            // Current Caregiver Booking
            const Text(
              'Current Caregiver Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<CaregiverBookingModel>(
                future: _currentCaregiverBooking,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No caregiver booking found');
                  } else {
                    final caregiverBooking = snapshot.data!;
                    return CaregiverBookingCard(
                      caregiverName: caregiverBooking.caregiverName,
                      startDate: caregiverBooking.startDate,
                      startTime: caregiverBooking.startTime,
                      endDate: caregiverBooking.endDate,
                      endTime: caregiverBooking.endTime,
                      location: caregiverBooking.location,
                      bookingID: caregiverBooking.bookingID,
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;

  const CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
