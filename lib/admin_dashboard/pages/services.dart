import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceDetailsPage extends StatelessWidget {
  final String bookingId;
  final String serviceType;

  const ServiceDetailsPage({
    Key? key,
    required this.bookingId,
    required this.serviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(serviceType == 'caregiver'
                ? 'CaregiverBooking'
                : 'DoctorBooking')
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Service not found'));
          }

          final serviceData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(context, serviceData),
                const SizedBox(height: 16),
                if (serviceType == 'doctor')
                  _buildDoctorDetails(context, serviceData)
                else
                  _buildCaregiverDetails(context, serviceData),
                const SizedBox(height: 16),
                _buildStatusCard(context, serviceData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(
      BuildContext context, Map<String, dynamic> serviceData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  serviceType == 'doctor'
                      ? Icons.medical_services
                      : Icons.elderly,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceType == 'doctor'
                            ? serviceData['doctorName'] ?? 'N/A'
                            : serviceData['caregiverName'] ?? 'N/A',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        serviceType.capitalize(),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorDetails(
      BuildContext context, Map<String, dynamic> serviceData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, Icons.person, 'Patient',
                serviceData['patientName'] ?? 'N/A'),
            _buildInfoRow(context, Icons.calendar_today, 'Date',
                serviceData['appointmentDate'] ?? 'N/A'),
            _buildInfoRow(context, Icons.access_time, 'Time',
                serviceData['appointmentTime'] ?? 'N/A'),
            _buildInfoRow(context, Icons.cake, 'Patient Age',
                serviceData['patientAge']?.toString() ?? 'N/A'),
            _buildInfoRow(context, Icons.description, 'Description',
                serviceData['description'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildCaregiverDetails(
      BuildContext context, Map<String, dynamic> serviceData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, Icons.location_on, 'Location',
                serviceData['location'] ?? 'N/A'),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Start Date',
              serviceData['startDate'] != null
                  ? DateFormat('MMM d, y')
                      .format(serviceData['startDate'].toDate())
                  : 'N/A',
            ),
            _buildInfoRow(context, Icons.access_time, 'Start Time',
                serviceData['startTime'] ?? 'N/A'),
            _buildInfoRow(
              context,
              Icons.event,
              'End Date',
              serviceData['endDate'] != null
                  ? DateFormat('MMM d, y')
                      .format(serviceData['endDate'].toDate())
                  : 'N/A',
            ),
            _buildInfoRow(context, Icons.schedule, 'Selected Time',
                serviceData['selectedTime'] ?? 'N/A'),
            _buildInfoRow(context, Icons.note, 'Special Notes',
                serviceData['specialNotes'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      BuildContext context, Map<String, dynamic> serviceData) {
    final status = serviceData['status'] ?? 'Pending';
    final statusColor = _getStatusColor(status);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Chip(
              label: Text(
                status,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
