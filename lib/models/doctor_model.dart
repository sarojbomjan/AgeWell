import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String email;
  final String phoneNo;
  final String address;
  final List<String> availability;
  final double rating;
  final int reviews;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.email,
    required this.phoneNo,
    required this.address,
    required this.availability,
    required this.rating,
    required this.reviews,
  });

  // Convert Doctor object to a Map<String, dynamic> for Firestore
  Map<String, dynamic> toMap() {
    return {
      'FullName': name,
      'Specialist': specialty,
      'Email': email,
      'Phone': phoneNo,
      'Address': address,
      'Availability': availability,
      'Ratings': rating,
      'Reviews': reviews,
    };
  }

  // Convert DocumentSnapshot to Doctor object
  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Doctor(
      id: doc.id,
      name: data['FullName'] ?? '',
      specialty: data['Specialist'] ?? '',
      email: data['Email'] ?? '',
      phoneNo: data['Phone'] ?? '',
      address: data['Address'] ?? '',
      availability: List<String>.from(data['Availability'] ?? []),
      rating: double.tryParse(data['Ratings']?.toString() ?? '0.0') ??
          0.0, // Convert from string to double
      reviews: int.tryParse(data['Reviews']?.toString() ?? '0') ??
          0, // Convert from string to int
    );
  }
}
