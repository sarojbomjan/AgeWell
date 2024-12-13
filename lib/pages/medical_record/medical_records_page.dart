import 'package:elderly_care/controller/personal_record_controller.dart';

import 'package:flutter/material.dart';
import 'package:elderly_care/pages/medical_record/allergies_record/allergy_page.dart';
import 'package:elderly_care/pages/medical_record/analysis_record/analysis_page.dart';
import 'package:elderly_care/pages/medical_record/medical_history_record/medical_history_page.dart';
import 'package:elderly_care/pages/medical_record/personal_record_page.dart';
import 'package:elderly_care/pages/medical_record/vaccination_record/vaccination_page.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  Map<String, dynamic>? personalRecord;
  bool isLoading = true;

  final PersonalRecordController _controller = PersonalRecordController();

  @override
  void initState() {
    super.initState();
    _fetchPersonalRecord();
  }

  // Fetching the personal record
  void _fetchPersonalRecord() async {
    setState(() {
      isLoading = true;
    });
    var record = await _controller.fetchPersonalRecord(context);

    setState(() {
      personalRecord = record;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Medical Record'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonalRecordPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Update Personal Record'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (personalRecord != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoText(
                            'Gender:', personalRecord!['gender'] ?? '-'),
                        _buildInfoText(
                            'Blood Type:', personalRecord!['bloodType'] ?? '-'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoText(
                            'Age:', '${personalRecord!['age'] ?? '-'} Years'),
                        _buildInfoText('Weight:',
                            '${personalRecord!['weight'] ?? '-'} Kg'),
                      ],
                    ),
                  ] else
                    const Center(
                      child: Text(
                        'No personal record found.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        _buildMenuButton(
                            'Allergies', Icons.medical_services, context),
                        _buildMenuButton('Analysis', Icons.analytics, context),
                        _buildMenuButton(
                            'Vaccinations', Icons.vaccines, context),
                        _buildMenuButton(
                            'Medical History', Icons.history, context),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoText(String title, String info) {
    return RichText(
      text: TextSpan(
        text: '$title ',
        style: const TextStyle(color: Colors.black, fontSize: 16),
        children: <TextSpan>[
          TextSpan(
            text: info,
            style: const TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, IconData icon, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'Allergies':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllergyPage(),
                ),
              );
              break;
            case 'Analysis':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnalysisPage(),
                ),
              );
              break;
            case 'Vaccinations':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VaccinationPage(),
                ),
              );
              break;
            case 'Medical History':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicalHistoryPage(),
                ),
              );
              break;
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.teal,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
