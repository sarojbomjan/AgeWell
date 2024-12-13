import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/services_booking/caretaker_page.dart';
import 'package:elderly_care/pages/services_booking/current_booking_card.dart';
import 'package:elderly_care/pages/services_booking/doctor_page.dart';
import 'package:elderly_care/pages/services_booking/old_age_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../models/doctor_booking_mode.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  late Future<BookingModel> _currentBooking;

  Future<BookingModel> _fetchCurrentBooking() async {
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    // Fetch the current booking for the user from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('APPOINTMENTS')
        .where('userId', isEqualTo: currentUserId) // Filter by userId
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Assuming only one booking per user, you can get the first document
      var doc = snapshot.docs.first;
      return BookingModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Booking not found');
    }
  }

  @override
  void initState() {
    super.initState();
    _currentBooking = _fetchCurrentBooking();
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
                      icon: Icons.handyman,
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
                      title: 'Emergency',
                      subtitle: 'Call',
                      icon: Icons.bus_alert,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Current Booking
            const Text(
              'Current Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            FutureBuilder(
                future: _currentBooking,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No booking found');
                  } else {
                    final booking = snapshot.data!;
                    return CurrentBookingCard(
                      title: booking.description,
                      doctorName: booking.doctorName,
                      date: booking.appointmentDate,
                      time: booking.appointmentTime,
                    );
                  }
                })
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
