import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/admin_dashboard/pages/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceListItem extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> serviceData;
  final String serviceType;

  const ServiceListItem({
    Key? key,
    required this.bookingId,
    required this.serviceData,
    required this.serviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceDate = serviceData['startDate'] != null
        ? DateFormat('MMM d, y')
            .format((serviceData['startDate'] as Timestamp).toDate())
        : 'N/A';
    final serviceTime = serviceData['startTime'] ?? 'N/A';
    final serviceStatus = serviceData['status'] ?? 'Pending';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _getServiceIcon(serviceType),
        title: Text(
          serviceType == 'doctor' ? 'DoctorBooking' : 'CaregiverBooking',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Date: $serviceDate'),
            Text('Time: $serviceTime'),
          ],
        ),
        trailing: Chip(
          label: Text(
            serviceStatus,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: _getStatusColor(serviceStatus),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailsPage(
                bookingId: bookingId,
                serviceType: serviceType,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getServiceIcon(String serviceType) {
    IconData iconData;
    Color iconColor;

    switch (serviceType.toLowerCase()) {
      case 'doctor':
        iconData = Icons.medical_services;
        iconColor = Colors.blue;
        break;
      case 'caregiver':
        iconData = Icons.elderly;
        iconColor = Colors.green;
        break;
      default:
        iconData = Icons.miscellaneous_services;
        iconColor = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor),
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
