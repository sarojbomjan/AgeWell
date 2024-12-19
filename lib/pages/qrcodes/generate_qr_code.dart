import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:elderly_care/models/user_model.dart';

import '../../models/allergy_model.dart';
import '../../models/analysis_record_model.dart';

class GenerateQrCode extends StatelessWidget {
  final UserModel userData;

  const GenerateQrCode({super.key, required this.userData});

  Future<Map<String, dynamic>> fetchQrData() async {
    final firestore = FirebaseFirestore.instance;

    // Fetch Medical Analysis data from the root collection
    final medicalAnalysisSnapshot = await firestore
        .collection('Medical_Analysis')
        .where('userId', isEqualTo: userData.uid)
        .get();

    MedicalAnalysis? medicalAnalysis;
    if (medicalAnalysisSnapshot.docs.isNotEmpty) {
      medicalAnalysis = MedicalAnalysis.fromMap(
          medicalAnalysisSnapshot.docs.first.data(),
          medicalAnalysisSnapshot.docs.first.id);
    }

    // Fetch Allergies data from the root collection
    final allergiesSnapshot = await firestore
        .collection('ALLERGIES')
        .where('userId', isEqualTo: userData.uid)
        .get();

    List<Allergy> allergies = allergiesSnapshot.docs
        .map((doc) => Allergy.fromFirestore(doc.id, doc.data()))
        .toList();

    return {
      'medicalAnalysis': medicalAnalysis,
      'allergies': allergies,
    };
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchQrData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching QR data. Please try again.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            final medicalAnalysis = snapshot.data!['medicalAnalysis'];
            final allergies = snapshot.data!['allergies'];

            // Build QR Data
            String qrData = "User Details:\n"
                "Name: ${userData.fullName}\n"
                "Address: ${userData.address}\n"
                "Email: ${userData.email}\n"
                "Phone: ${userData.phoneNo}\n\n";

            if (medicalAnalysis != null) {
              qrData += "Medical Analysis:\n"
                  "Test Date: ${medicalAnalysis.testDate ?? 'N/A'}\n"
                  "Fasting Levels: ${medicalAnalysis.fastingLevels ?? 'N/A'}\n"
                  "OGTT: ${medicalAnalysis.ogtt ?? 'N/A'}\n"
                  "HbA1c: ${medicalAnalysis.hba1c ?? 'N/A'}\n"
                  "Uric Acid: ${medicalAnalysis.uricAcid ?? 'N/A'}\n"
                  "Blood Sugar: ${medicalAnalysis.bloodSugar ?? 'N/A'}\n"
                  "Cholesterol: ${medicalAnalysis.cholesterol ?? 'N/A'}\n\n";
            }

            if (allergies.isNotEmpty) {
              qrData += "Allergies:\n";
              for (var allergy in allergies) {
                qrData +=
                    "- ${allergy.name ?? 'N/A'} (Symptoms: ${allergy.symptoms ?? 'N/A'}, Date: ${allergy.date ?? 'N/A'})\n";
              }
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrettyQr(
                    data: qrData,
                    size: 250.0,
                    roundEdges: true,
                    elementColor: isDarkMode ? Colors.white : Colors.black,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      "Scan this QR code to view user and medical details"),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No data available for QR code.'),
            );
          }
        },
      ),
    );
  }
}
