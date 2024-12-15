import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/pages/services_booking/caretaker_service/caretaker_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/caregiver_model.dart';

class CaretakerPage extends StatefulWidget {
  const CaretakerPage({super.key});

  @override
  State<CaretakerPage> createState() => _CaretakerPageState();
}

class _CaretakerPageState extends State<CaretakerPage> {
  Future<List<CaregiverModel>>? caretakerList;

  List<String> generateDays() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return DateFormat('EEE dd').format(date);
    });
  }

  Future<List<CaregiverModel>> fetchCaregivers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('Role', isEqualTo: 'Caregiver')
          .get();

      List<CaregiverModel> caregivers = querySnapshot.docs.map((doc) {
        var caretaker = CaregiverModel.fromFirestore(doc);

        return caretaker;
      }).toList();

      return caregivers;
    } catch (e) {
      print('Error fetching caregivers: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    caretakerList = fetchCaregivers();
  }

  @override
  Widget build(BuildContext context) {
    final days = generateDays();
    final currentDate = DateFormat('EEE dd').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caretaker Appointment'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days
                  .map((day) => Column(
                        children: [
                          Text(
                            day.split(' ')[0],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: day == currentDate
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            day.split(' ')[1],
                            style: TextStyle(
                              color: day == currentDate
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Caretakers Availability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: caretakerList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Error loading caregiver.'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No caregivers found.'));
                  }

                  final caretakers = snapshot.data!;
                  return ListView.builder(
                    itemCount: caretakers.length,
                    itemBuilder: (context, index) {
                      final caretaker = caretakers[index];
                      return CaretakerCard(caretaker: caretaker);
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

class CaretakerCard extends StatefulWidget {
  final CaregiverModel caretaker;

  const CaretakerCard({required this.caretaker});

  @override
  _CaretakerCardState createState() => _CaretakerCardState();
}

class _CaretakerCardState extends State<CaretakerCard> {
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CaretakerProfile(caregiverID: widget.caretaker.id),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("lib/images/user.webp"),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.caretaker.fullName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.caretaker.email,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            Text(
                              '${widget.caretaker.experienceYears} Years (${widget.caretaker.workHours} Available)',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
