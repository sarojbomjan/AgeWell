// lib/pages/doctor_page.dart
import 'package:elderly_care/pages/services_booking/doctor_service/doctor_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../models/doctor_model.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  Future<List<Doctor>>? doctorList;

  // Fetch doctors from Firestore
  Future<List<Doctor>> fetchDoctors() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('Role', isEqualTo: 'Doctor')
          .get();

      List<Doctor> doctors = querySnapshot.docs.map((doc) {
        var doctor = Doctor.fromFirestore(doc);
        print(doctor.name); // Log doctor name to verify the data
        return doctor;
      }).toList();

      return doctors;
    } catch (e) {
      print('Error fetching doctors: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    doctorList = fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return DateFormat('EEE dd').format(date);
    });

    final currentDate = DateFormat('EEE dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Appointment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((day) {
                final isSelected = day == currentDate;
                return Column(
                  children: [
                    Text(
                      day.split(' ')[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    Text(
                      day.split(' ')[1],
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Doctors Availability
            const Text(
              'Doctors Availability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Doctor>>(
                future: doctorList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading doctors.'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No doctors found.'));
                  }

                  final doctors = snapshot.data!;
                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return DoctorCard(doctor: doctor);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Pass the doctor id to DoctorProfile
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorProfile(doctorId: doctor.id),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage("lib/images/user.webp"),
                    radius: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        doctor.specialty,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.yellow, size: 16),
                          Text('${doctor.rating} (${doctor.reviews} Reviews)'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: doctor.availability.map((time) {
                return ElevatedButton(
                  onPressed: () {
                    _bookAppointment(context, doctor, time);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(time),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _bookAppointment(BuildContext context, Doctor doctor, String time) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book Appointment'),
          content: Text(
              'Do you want to book an appointment with ${doctor.name} at $time?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add booking logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Appointment booked with ${doctor.name} at $time'),
                  ),
                );
              },
              child: const Text('Book'),
            ),
          ],
        );
      },
    );
  }
}
