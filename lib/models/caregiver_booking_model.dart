import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CaregiverBookingModel {
  final String bookingID;
  final String caregiverID;
  final DateTime startDate;
  final String startTime;
  final DateTime endDate;
  final String endTime;
  final String selectedTime;
  final String location;
  final String specialNotes;
  final Timestamp createdAt;
  final String userID;
  final String caregiverName;

  CaregiverBookingModel({
    this.bookingID = "",
    required this.caregiverID,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.selectedTime,
    required this.location,
    required this.specialNotes,
    required this.createdAt,
    required this.userID,
    required this.caregiverName,
  });

  Map<String, dynamic> toMap() {
    return {
      'caregiverID': caregiverID,
      'startDate': startDate,
      'startTime': startTime,
      'endDate': endDate,
      'endTime': endTime,
      'selectedTime': selectedTime,
      'location': location,
      'specialNotes': specialNotes,
      'createdAt': createdAt,
      'userID': userID,
      'caregiverName': caregiverName,
    };
  }

  factory CaregiverBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime startDate = _getDateTimeFromFirestore(data['startDate']);
    DateTime endDate = _getDateTimeFromFirestore(data['endDate']);

    return CaregiverBookingModel(
      bookingID: doc.id, // Get the Firestore document ID as bookingID
      caregiverID: data['caregiverID'] ?? '',
      startDate: startDate,
      startTime: data['startTime'] ?? '',
      endDate: endDate,
      endTime: data['endTime'] ?? '',
      selectedTime: data['selectedTime'] ?? '',
      location: data['location'] ?? '',
      specialNotes: data['specialNotes'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      userID: data['userID'] ?? '',
      caregiverName: data['caregiverName'] ?? '',
    );
  }

  // Helper function to handle Timestamp to DateTime conversion
  static DateTime _getDateTimeFromFirestore(dynamic field) {
    if (field is Timestamp) {
      return field.toDate();
    }
    return DateTime.now(); //
  }

  String formattedStartDate() {
    return DateFormat('d MMM, yyyy').format(startDate); // Format startDate
  }

  String formattedEndDate() {
    return DateFormat('d MMM, yyyy').format(endDate); // Format endDate
  }
}
