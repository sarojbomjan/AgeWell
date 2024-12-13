import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/analysis_record_model.dart';

class AnalysisController {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('Medical_Analysis');

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Add new analysis record
  Future<void> addAnalysis(MedicalAnalysis analysis) async {
    if (userId == null) throw Exception("User not authenticated");
    await _collection.doc(userId).set(analysis.toMap());
  }

  // Update an analysis record
  Future<void> updateAnalysis(MedicalAnalysis analysis) async {
    if (userId == null) throw Exception("User not authenticated");
    await _collection.doc(userId).update(analysis.toMap());
  }

  // Delete an analysis record
  Future<void> deleteAnalysis(String id) async {
    await _collection.doc(id).delete();
  }

  // Fetch analysis records for the current user
  Stream<MedicalAnalysis?> getAnalysis() {
    if (userId == null) throw Exception("User not authenticated");
    return _collection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return MedicalAnalysis.fromMap(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        return null;
      }
    });
  }
}
