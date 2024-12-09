import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String fullName;
  final String email;
  final String phoneNo;
  final String address;
  final String
      role; // This field will store roles like 'customer', 'caretaker', 'doctor'

  // Constructor
  const UserModel({
    this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.address,
    this.role = 'customer', // Default to 'customer'
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "UID": uid,
      "FullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Address": address,
      "Role": role,
    };
  }

  // map user fetched from Firebase to UserModel
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    return UserModel(
      uid: snapshot.id,
      fullName: json['FullName'],
      email: json['Email'],
      phoneNo: json['Phone'],
      address: json['Address'],
      role: json['Role'] ?? 'customer', // Default to 'customer'
    );
  }
}
