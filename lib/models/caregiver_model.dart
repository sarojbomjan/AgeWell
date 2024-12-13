import 'package:cloud_firestore/cloud_firestore.dart';

class CaregiverModel {
  String id;
  String fullName;
  String email;
  String phoneNo;
  String address;
  String gender;
  DateTime? dateOfBirth;
  int experienceYears;
  List<String> skills;
  List<String> languagesSpoken;
  String workHours;

  CaregiverModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.address,
    required this.gender,
    required this.experienceYears,
    required this.skills,
    required this.languagesSpoken,
    required this.workHours,
  });

  // Convert a CaregiverModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FullName': fullName,
      'Email': email,
      'Phone': phoneNo,
      'Address': address,
      'Gender': gender,
      'Experience': experienceYears,
      'Skills': skills,
      'Languages': languagesSpoken,
      'WorkHours': workHours,
    };
  }

  factory CaregiverModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CaregiverModel(
      id: doc.id,
      fullName: data['FullName'] ?? 'No Name',
      email: data['Email'] ?? 'No Email',
      phoneNo: data['Phone'] ?? 'No Phone',
      address: data['Address'] ?? 'No Address',
      gender: data['Gender'] ?? 'Not Specified',
      experienceYears: int.tryParse(data['Experience'].toString()) ??
          0, // Convert string to int
      skills: _convertToList(data['Skills']),
      languagesSpoken: _convertToList(data['Languages']),
      workHours: data['WorkHours'] ?? 'Not Specified',
    );
  }
}

// Helper method to handle both String and List types
List<String> _convertToList(dynamic value) {
  if (value is String) {
    return value
        .split(',')
        .map((e) => e.trim())
        .toList(); // Split string into list
  } else if (value is List) {
    return List<String>.from(value);
  }
  return []; // Return empty list if the value is null or not a string/list
}
