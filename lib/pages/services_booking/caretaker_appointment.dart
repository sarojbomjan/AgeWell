import 'package:elderly_care/pages/services_booking/caretaker_service/caretaker_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaretakerAppointment extends StatefulWidget {
  const CaretakerAppointment({super.key});

  @override
  State<CaretakerAppointment> createState() => _CaretakerAppointmentState();
}

class _CaretakerAppointmentState extends State<CaretakerAppointment> {
  List<String> generateDays() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return DateFormat('EEE dd').format(date);
    });
  }

  final List<Caretaker> caretakers = [
    Caretaker(
      name: 'Alex Smith',
      specialty: 'Senior Care Specialist',
      rating: 4.8,
      reviews: 34,
      availability: ['08:00', '09:00', '10:00', '11:00', '13:00', '15:00'],
      imageUrl: 'assets/images/caretaker1.png',
    ),
    Caretaker(
      name: 'Emma Johnson',
      specialty: 'Certified Caregiver',
      rating: 4.6,
      reviews: 22,
      availability: ['09:00', '11:00', '13:00', '15:00', '17:00'],
      imageUrl: 'assets/images/caretaker2.png',
    ),
  ];

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
              children: days.map((day) => Column(
                children: [
                  Text(
                    day.split(' ')[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: day == currentDate ? Colors.blue : Colors.black,
                    ),
                  ),
                  Text(
                    day.split(' ')[1],
                    style: TextStyle(
                      color: day == currentDate ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              )).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Caretakers Availability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: caretakers.length,
                itemBuilder: (context, index) {
                  final caretaker = caretakers[index];
                  return CaretakerCard(caretaker: caretaker);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Caretaker {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final List<String> availability;
  final String imageUrl;

  Caretaker({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.availability,
    required this.imageUrl,
  });
}

class CaretakerCard extends StatefulWidget {
  final Caretaker caretaker;

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
                    builder: (context) => CaretakerProfile(),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.caretaker.imageUrl),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.caretaker.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.caretaker.specialty,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 16),
                            Text('${widget.caretaker.rating} (${widget.caretaker.reviews} Reviews)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_right
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}