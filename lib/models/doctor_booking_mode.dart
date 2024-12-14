import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingID;
  final String appointmentDate;
  final String appointmentTime;
  final String description;
  final String doctorId;
  final String patientAge;
  final String patientName;
  final String userId;
  final String doctorName;

  BookingModel(
      {this.bookingID = "",
      required this.appointmentDate,
      required this.appointmentTime,
      required this.description,
      required this.doctorId,
      required this.patientAge,
      required this.patientName,
      required this.userId,
      required this.doctorName});

  // Convert BookingModel object to Map<String, dynamic> for Firestore
  Map<String, dynamic> toMap() {
    return {
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'description': description,
      'doctorId': doctorId,
      'patientAge': patientAge,
      'patientName': patientName,
      'userId': userId,
      "doctorName": doctorName,
    };
  }

  // Convert Map<String, dynamic> to BookingModel object
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      bookingID: doc.id,
      appointmentDate: data['appointmentDate'] ?? '',
      appointmentTime: data['appointmentTime'] ?? '',
      description: data['description'] ?? '',
      doctorId: data['doctorId'] ?? '',
      patientAge: data['patientAge'] ?? '',
      patientName: data['patientName'] ?? '',
      userId: data['userId'] ?? '',
      doctorName: data['doctorName'] ?? '',
    );
  }
}
