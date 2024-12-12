import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../controller/doctor_appointment_controller.dart';

class DoctorAppointmentBooking extends StatefulWidget {
  final String doctorId;
  const DoctorAppointmentBooking({super.key, required this.doctorId});

  @override
  State<DoctorAppointmentBooking> createState() =>
      _DoctorAppointmentBookingState();
}

class _DoctorAppointmentBookingState extends State<DoctorAppointmentBooking> {
  // Sample data
  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List<String> availableTimes = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "12:00 PM",
    "12:30 PM",
    "01:30 PM",
    "03:00 PM",
    "04:30 PM",
    "05:30 PM",
  ];

  String selectedDate = "";
  String selectedTime = "12:30 PM";
  final TextEditingController fullNameController =
      TextEditingController(text: "Your Name");
  String selectedAge = "41 - 50";
  final TextEditingController descriptionController = TextEditingController();

  // Doctor data in a Map
  // Doctor details
  String doctorName = "";
  String doctorSpecialization = "";

  @override
  void initState() {
    super.initState();
    // Initialize the selected date as today's date
    final DateTime now = DateTime.now();
    selectedDate = now.day.toString();
    _fetchDoctorDetails();
  }

  // fetch doctor details
  Future<void> _fetchDoctorDetails() async {
    try {
      // Fetch doctor details from Firestore using doctorId
      final docSnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .doc(widget.doctorId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          doctorName = docSnapshot['FullName'];
          doctorSpecialization = docSnapshot['Specialist'];
        });
      } else {
        // Handle if the doctor document is not found
        print('Doctor not found');
      }
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  // Store appointment in Firestore
  Future<void> _storeAppointment() async {
    try {
      await bookAppointment(
        doctorId: widget.doctorId,
        patientName: fullNameController.text,
        patientAge: selectedAge,
        appointmentDate: selectedDate,
        appointmentTime: selectedTime,
        description: descriptionController.text,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully!')),
      );

      // Optionally navigate back after booking
      Navigator.pop(context);
    } catch (e) {
      print('Error storing appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String currentMonth = "${now.month}, ${now.year}";
    // final String currentDay = days[now.weekday - 1]; // Get the weekday

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorName.isNotEmpty ? doctorName : "Loading...",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              doctorSpecialization.isNotEmpty
                  ? doctorSpecialization
                  : "Loading...",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date selection
              Text(
                currentMonth,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected =
                        selectedDate == (now.day + index).toString();
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = (now.day + index).toString();
                        });
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              days[(now.weekday - 1 + index) %
                                  7], // Dynamically adjust days
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (now.day + index).toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Time selection
              const Text(
                "Available Time",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: availableTimes.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedTime == availableTimes[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = availableTimes[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          availableTimes[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Patient Details
              const Text(
                "Patient Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: "Full name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedAge,
                items: [
                  "18 - 25",
                  "26 - 30",
                  "31 - 40",
                  "41 - 50",
                  "51+",
                ].map((age) {
                  return DropdownMenuItem(
                    value: age,
                    child: Text(age),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAge = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Set Appointment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  onPressed: () {
                    _storeAppointment();
                  },
                  child: const Text(
                    "Set Appointment",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
