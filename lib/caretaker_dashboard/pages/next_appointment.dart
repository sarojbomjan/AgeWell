import 'package:flutter/material.dart';

class NextAppointment extends StatefulWidget {
  const NextAppointment({super.key});

  @override
  State<NextAppointment> createState() => _NextAppointmentState();
}

class _NextAppointmentState extends State<NextAppointment> {
  // Sample data for appointments
  final List<Map<String, String>> appointments = [
    {
      'hire': 'Joh Smith',
      'start date': '2024-12-15',
      'start time': '10:00 AM',
      'end date': '2024-12-15',
      'end time': '10:00 AM',
      'shift': 'Morning',
      'location': 'Room 101',
      'special notes': 'Health Issues',
    },
    {
      'hire': 'Bon Smith',
      'start date': '2024-12-15',
      'start time': '10:00 AM',
      'end date': '2024-12-15',
      'end time': '10:00 AM',
      'shift': 'Morning',
      'location': 'Room 101',
      'special notes': 'Health Issues',
    },
    {
      'hire': 'Mon Smith',
      'start date': '2024-12-15',
      'start time': '10:00 AM',
      'end date': '2024-12-15',
      'end time': '10:00 AM',
      'shift': 'Morning',
      'location': 'Room 101',
      'special notes': 'Health Issues',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Appointments'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                'Hired by ${appointment['hire']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: (${appointment['start date']}) - (${appointment['end date']})'),
                  Text('Time: ${appointment['start time']} - ${appointment['end time']}'),
                  Text('Shift: ${appointment['shift']}'),
                  Text('Location: ${appointment['location']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
