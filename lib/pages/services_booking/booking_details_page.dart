import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../models/caregiver_booking_model.dart';
import '../../models/doctor_booking_mode.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingID; // Firestore document ID
  final String bookingType; // Type: 'doctor' or 'caregiver'
  const BookingDetailsPage({
    Key? key,
    required this.bookingID,
    required this.bookingType,
  }) : super(key: key);
  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late Future<dynamic> _bookingFuture;
  @override
  void initState() {
    super.initState();
    _bookingFuture = fetchBookingDetails();
  }

  Future<dynamic> fetchBookingDetails() async {
    final docRef = FirebaseFirestore.instance
        .collection(widget.bookingType == 'doctor'
            ? 'DoctorBooking'
            : 'CaregiverBooking')
        .doc(widget.bookingID);
    print('Booking Type: ${widget.bookingType}');
    print('Fetching Booking with ID: ${widget.bookingID}');
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception('Booking not found');
    }
    // Safely get the data from Firestore (handling null values)
    var data = docSnapshot.data();
    if (data == null) {
      print('Fetched Data: $data');
      throw Exception('Document data is null');
    }
    // Log the data for debugging
    print('Fetched Data: $data');
    print('Document data: ${docSnapshot.data()}');
    // Map data to appropriate model
    if (widget.bookingType == 'doctor') {
      return BookingModel.fromFirestore(docSnapshot);
    } else if (widget.bookingType == 'caregiver') {
      return CaregiverBookingModel.fromFirestore(docSnapshot);
    } else {
      throw Exception('Invalid booking type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: _bookingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No booking details found.'));
          } else {
            final booking = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookingType == 'doctor'
                                  ? booking.doctorName
                                  : booking.caregiverName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDetailRow(
                              Icons.calendar_today,
                              'Date',
                              widget.bookingType == 'doctor'
                                  ? booking.appointmentDate
                                  : DateFormat('d MMM, yyyy')
                                      .format(booking.startDate),
                            ),
                            const SizedBox(height: 10),
                            _buildDetailRow(
                                Icons.access_time,
                                'Time',
                                widget.bookingType == 'doctor'
                                    ? booking.appointmentTime
                                    : booking.startTime),
                            const SizedBox(height: 10),
                            if (widget.bookingType == 'doctor')
                              _buildDetailRow(
                                  Icons.person, 'Patient', booking.patientName),
                            if (widget.bookingType == 'caregiver')
                              _buildDetailRow(Icons.location_on, 'Location',
                                  booking.location),
                            const SizedBox(height: 20),
                            const Text(
                              'Additional Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.bookingType == 'doctor'
                                  ? booking.description
                                  : booking.specialNotes,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showRescheduleModal,
                            child: const Text('Reschedule'),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _cancelAppointment,
                            child: const Text('Cancel'),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showRescheduleModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reschedule Appointment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Date'),
                      subtitle:
                          Text(DateFormat('d MMM, y').format(DateTime.now())),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setModalState(() {});
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time'),
                      subtitle: Text('Pick new time'),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setModalState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic to save the new rescheduled time
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Appointment rescheduled successfully'),
                            ),
                          );
                        },
                        child: const Text('Confirm Reschedule'),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _cancelAppointment() {
    // Logic to cancel the appointment
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment canceled successfully'),
      ),
    );
  }
}
