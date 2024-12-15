import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/models/caregiver_booking_model.dart';
import 'package:elderly_care/models/caregiver_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaretakerProfile extends StatefulWidget {
  final String caregiverID;

  const CaretakerProfile({Key? key, required this.caregiverID})
      : super(key: key);

  @override
  State<CaretakerProfile> createState() => _CaretakerProfileState();
}

class _CaretakerProfileState extends State<CaretakerProfile> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _specialNotesController = TextEditingController();

  final List<String> availableTimes = [
    "Morning",
    "Evening",
    "Night",
    "Morning + Evening",
    "Evening + Night",
    "Morning + Night",
    "Full Time",
  ];

  String selectedTime = "Full Time";
  String caregiverName = "Loading...";

  // Store caregiver details
  CaregiverModel? caregiverDetails;

  @override
  void initState() {
    super.initState();
    _fetchCaregiverDetails();
  }

  Future<void> _fetchCaregiverDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .doc(widget.caregiverID)
          .get();

      if (docSnapshot.exists) {
        final doc = docSnapshot.data();
        setState(() {
          caregiverDetails = CaregiverModel.fromFirestore(docSnapshot);
          caregiverName = caregiverDetails?.fullName ?? 'Unknown Caregiver';
        });
      } else {
        setState(() {
          caregiverName = 'Caregiver not found';
        });
      }
    } catch (e) {
      setState(() {
        caregiverName = 'Error fetching caregiver';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _startDateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _startTimeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _endDateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _endTimeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _saveBooking() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DateTime startDate =
          DateFormat('MM/dd/yyyy').parse(_startDateController.text);
      DateTime endDate =
          DateFormat('MM/dd/yyyy').parse(_endDateController.text);

      final booking = CaregiverBookingModel(
        caregiverID: widget.caregiverID,
        startDate: startDate,
        startTime: _startTimeController.text,
        endDate: endDate,
        endTime: _endTimeController.text,
        selectedTime: selectedTime,
        location: _locationController.text,
        specialNotes: _specialNotesController.text,
        createdAt: Timestamp.now(),
        userID: userId,
        caregiverName: caregiverName,
      );

      await FirebaseFirestore.instance
          .collection('CaregiverBooking')
          .add(booking.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),
      );

      // Clear the form after booking
      setState(() {
        selectedTime = "Full Time";
      });
      _startDateController.clear();
      _startTimeController.clear();
      _endDateController.clear();
      _endTimeController.clear();
      _locationController.clear();
      _specialNotesController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (caregiverDetails == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("lib/images/user.webp"),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    caregiverDetails!.fullName,
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
                        caregiverDetails!.phoneNo,
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
                        caregiverDetails!.email,
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
            Text(
              'Book an Appointment with $caregiverName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                labelText: 'Select Start Date',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectStartDate(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _startTimeController,
              decoration: InputDecoration(
                labelText: 'Select Start Time',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () => _selectStartTime(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                labelText: 'Select End Date',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectEndDate(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _endTimeController,
              decoration: InputDecoration(
                labelText: 'Select End Time',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () => _selectEndTime(context),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTime,
              items: availableTimes.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Shift",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _specialNotesController,
              decoration: const InputDecoration(
                labelText: 'Any Special Notes?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _saveBooking,
                child: const Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
