import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> bookAppointment({
  required String doctorId,
  required String patientName,
  required String patientAge,
  required String appointmentDate,
  required String appointmentTime,
  required String description,
}) async {
  try {
    final appointmentData = {
      'doctorId': doctorId,
      'patientName': patientName,
      'patientAge': patientAge,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'description': description,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Store appointment in Firestore
    await FirebaseFirestore.instance
        .collection('APPOINTMENTS')
        .add(appointmentData);
  } catch (e) {
    print('Error storing appointment: $e');
    rethrow;
  }
}
