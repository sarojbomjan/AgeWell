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
  Future<List<BookingModel>>? _currentBooking;
  Future<List<CaregiverBookingModel>>? _currentCaregiverBooking;

// Fetch the current doctor booking for the user
  Future<List<BookingModel>> _fetchCurrentBooking() async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('DoctorBooking')
        .where('userId', isEqualTo: currentUserId) // Filter by userId
        .get();

    return snapshot.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
  }

// Fetch the current caregiver booking for the user
  Future<List<CaregiverBookingModel>> _fetchCaregiverBooking() async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('CaregiverBooking')
        .where('userID', isEqualTo: currentUserId)
        .get();

    return snapshot.docs
        .map((doc) => CaregiverBookingModel.fromFirestore(doc))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _currentBooking = _fetchCurrentBooking();
    _currentCaregiverBooking = _fetchCaregiverBooking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Booking'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                              builder: (context) => const DoctorPage()),
                        );
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
                              builder: (context) => const CaretakerPage()),
                        );
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
              FutureBuilder<List<BookingModel>>(
                future: _currentBooking,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('No doctor booking found');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No doctor booking found');
                  } else {
                    final bookings = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return CurrentBookingCard(
                          title: booking.description,
                          doctorName: booking.doctorName,
                          date: booking.appointmentDate,
                          time: booking.appointmentTime,
                          bookingType: 'doctor',
                          bookingID: booking.bookingID,
                        );
                      },
                    );
                  }
                },
              ),

              const SizedBox(height: 20),

              // Current Caregiver Booking
              const Text(
                'Current Caregiver Booking',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<CaregiverBookingModel>>(
                future: _currentCaregiverBooking,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(
                        'No caregiver booking available, book now');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No caregiver booking found');
                  } else {
                    final caregiverBookings = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: caregiverBookings.length,
                      itemBuilder: (context, index) {
                        final caregiverBooking = caregiverBookings[index];
                        return CaregiverBookingCard(
                          caregiverName: caregiverBooking.caregiverName,
                          startDate: caregiverBooking.startDate,
                          startTime: caregiverBooking.startTime,
                          endDate: caregiverBooking.endDate,
                          endTime: caregiverBooking.endTime,
                          location: caregiverBooking.location,
                          bookingID: caregiverBooking.bookingID,
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
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
