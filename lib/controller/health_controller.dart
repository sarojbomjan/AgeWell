import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save heart rate data to Firestore
  Future<void> saveHeartRate(int bpm) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final record = {
        'userId': userId,
        'bpm': bpm,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('HEALTHDATA').add(record);
    } catch (e) {
      print("Error saving heart rate: $e");
    }
  }

  // Fetch heart rate records from Firestore
  Future<List<HeartRateRecord>> fetchHeartRateRecords() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      final querySnapshot = await _firestore
          .collection('HEALTHDATA')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return HeartRateRecord(
          data['timestamp']?.toDate() ?? DateTime.now(),
          data['bpm'] as int,
        );
      }).toList();
    } catch (e) {
      print("Error fetching heart rate records: $e");
      return [];
    }
  }
}

class HeartRateRecord {
  final DateTime date;
  final int bpm;

  HeartRateRecord(this.date, this.bpm);
}
