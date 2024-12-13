import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalRecordController {
  // Method to fetch personal record
  Future<Map<String, dynamic>?> fetchPersonalRecord(
      BuildContext context) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("User not logged in");
      }

      final doc = await FirebaseFirestore.instance
          .collection('Personal Records')
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data(); // Return personal record data
      } else {
        return null; // Return null if no data is found
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching record: $e')),
      );
      return null;
    }
  }
}
