import 'package:elderly_care/pages/services_booking/doctor_service/doctor_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  List<String> generateDays() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return DateFormat('EEE dd').format(date);
    });
  }

  final List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Darshana Perera',
      specialty: 'Consultant - Physiotherapy',
      rating: 4.9,
      reviews: 28,
      availability: ['09:00', '10:00', '11:00', '12:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00'],
      imageUrl: 'assets/images/doctor1.png',
    ),
    Doctor(
      name: 'Dr. Prabashi Rathnayake',
      specialty: 'Consultant - Cardiologist',
      rating: 4.2,
      reviews: 19,
      availability: ['08:00', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00', '22:00'],
      imageUrl: 'assets/images/doctor2.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final days = generateDays();
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
              children: days
                  .map((day) => Column(
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
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            // Doctors Availability
            const Text(
              'Doctors Availability',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return DoctorCard(doctor: doctor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final List<String> availability;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.availability,
    required this.imageUrl,
  });
}

class DoctorCard extends StatefulWidget {
  final Doctor doctor;

  const DoctorCard({required this.doctor});

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool isExpanded = false;

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
                    builder: (context) => DoctorProfile(),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.doctor.imageUrl),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.doctor.specialty,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 16),
                            Text('${widget.doctor.rating} (${widget.doctor.reviews} Reviews)'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: widget.doctor.availability.map((time) {
                  return ElevatedButton(
                    onPressed: () {
                      _bookAppointment(context, widget.doctor, time);
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
          ],
        ),
      ),
    );
  }
}
  void _bookAppointment(BuildContext context, Doctor doctor, String time) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Book Appointment'),
          content: Text('Do you want to book an appointment with ${doctor.name} at $time?'),
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
                  SnackBar(content: Text('Appointment booked with ${doctor.name} at $time')),
                );
              },
              child: const Text('Book'),
            ),
          ],
        );
      },
    );
  }

