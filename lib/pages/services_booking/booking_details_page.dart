import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsPage extends StatefulWidget {
  final String title;
  final String doctorName;
  final String date;
  final String time;

  const BookingDetailsPage({
    Key? key,
    required this.title,
    required this.doctorName,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    // Attempt to parse the date with 'd MMM' format
    try {
      _selectedDate = DateFormat('d MMM').parse(widget.date);
    } catch (e) {
      // If parsing fails, fall back to a default date or handle the error
      _selectedDate = DateTime.now(); // Default to today's date if invalid
    }

    // Convert the string time to TimeOfDay
    final timeParts = widget.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1].split(' ')[0]);
    _selectedTime = TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        widget.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow(
                          Icons.person, 'Doctor', widget.doctorName),
                      const SizedBox(height: 10),
                      _buildDetailRow(Icons.calendar_today, 'Date',
                          DateFormat('d MMM, y').format(_selectedDate)),
                      const SizedBox(height: 10),
                      _buildDetailRow(Icons.access_time, 'Time', widget.time),
                      const SizedBox(height: 10),
                      _buildDetailRow(Icons.location_on, 'Location',
                          '123 Medical Center, City'),
                      const SizedBox(height: 20),
                      const Text(
                        'Additional Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Please arrive 15 minutes before your scheduled appointment time. '
                        'Bring any relevant medical records or test results. '
                        'If you need to cancel or reschedule, please do so at least 24 hours in advance.',
                        style: TextStyle(fontSize: 16),
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
                      onPressed: () {
                        // Add functionality to cancel appointment
                      },
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
                          Text(DateFormat('d MMM, y').format(_selectedDate)),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null &&
                            !picked.isAtSameMomentAs(_selectedDate)) {
                          setModalState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time'),
                      subtitle: Text(_selectedTime.format(context)),
                      onTap: () async {
                        final DateTime initialDate =
                            _selectedDate.isBefore(DateTime.now())
                                ? DateTime.now()
                                : _selectedDate;
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (picked != null && picked != _selectedTime) {
                          setModalState(() {
                            _selectedTime = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement the logic to save the new appointment time
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
}
