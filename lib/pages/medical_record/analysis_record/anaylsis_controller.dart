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

    analysis.userId = userId!;

    await _collection.add(analysis.toMap());
  }

  // Update an analysis record
  Future<void> updateAnalysis(MedicalAnalysis analysis) async {
    if (userId == null) throw Exception("User not authenticated");
    if (analysis.id == null)
      throw Exception("Analysis ID is required for updates");

    await _collection.doc(analysis.id).update(analysis.toMap());
  }

  // Delete an analysis record
  Future<void> deleteAnalysis(String id) async {
    await _collection.doc(id).delete();
  }

  // Fetch analysis records for the current user
  Stream<List<MedicalAnalysis>> getUserAnalyses() {
    if (userId == null) throw Exception("User not authenticated");

    return _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MedicalAnalysis.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
