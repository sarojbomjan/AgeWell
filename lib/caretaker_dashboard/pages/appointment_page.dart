import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const ScheduleContent(),
    );
  }
}

class ScheduleContent extends StatelessWidget {
  const ScheduleContent({Key? key}) : super(key: key);

  Future<List<Appointment>> _fetchAppointments() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('CaretakerBooking').get();

    return querySnapshot.docs.map((doc) {
      return Appointment(
        patientName: doc['patientName'],
        time: (doc['time'] as Timestamp).toDate(),
        type: doc['type'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: _fetchAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No appointments available.'));
        }

        final appointments = snapshot.data!;

        return Column(
          children: [
            _buildDateHeader(context),
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return _buildAppointmentCard(context, appointments[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEEE, MMMM d').format(DateTime.now()),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement date picker
            },
            child: const Text('Change Date'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Appointment appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            appointment.patientName.substring(0, 1),
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        title: Text(
          appointment.patientName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          '${DateFormat('h:mm a').format(appointment.time)} - ${appointment.type}',
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            _showAppointmentDetails(context, appointment);
          },
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointment Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Patient', appointment.patientName),
              _buildDetailRow(
                  'Time', DateFormat('h:mm a').format(appointment.time)),
              _buildDetailRow('Type', appointment.type),
              _buildDetailRow('Duration', '1 hour'),
              _buildDetailRow('Location', 'Room 101'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class Appointment {
  final String patientName;
  final DateTime time;
  final String type;

  Appointment({
    required this.patientName,
    required this.time,
    required this.type,
  });
}
