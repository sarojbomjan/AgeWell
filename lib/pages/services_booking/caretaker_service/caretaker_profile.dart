// lib/pages/caretaker_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/caregiver_model.dart';
import 'package:flutter/material.dart';

import 'care_taker_appointment.dart';

class CaretakerProfile extends StatefulWidget {
  final String caregiverID;

  const CaretakerProfile({super.key, required this.caregiverID});

  @override
  State<CaretakerProfile> createState() => _CaretakerProfileState();
}

class _CaretakerProfileState extends State<CaretakerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElderlyCare'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("USERS")
            .doc(widget.caregiverID)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Caretaker not found.'));
          }
          final caregiverDetails = CaregiverModel.fromFirestore(snapshot.data!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("lib/images/user.webp")),
                      const SizedBox(height: 16),
                      Text(
                        caregiverDetails.fullName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Available: 10:00 AM to 4:00 PM',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            caregiverDetails.phoneNo,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            caregiverDetails.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                BookAppointment(caregiverID: widget.caregiverID),
              ],
            ),
          );
        },
      ),
    );
  }
}
