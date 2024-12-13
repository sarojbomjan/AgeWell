import 'package:elderly_care/pages/medical_record/medical_history_record/medical_history_form.dart';
import 'package:flutter/material.dart';


class MedicalHistoryPage extends StatefulWidget {
  const MedicalHistoryPage({super.key});

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final List<Map<String, String>> medicalHistory = [
    {
      'condition': 'Diabetes',
      'doctor': 'Dr. Emma Hall, M.D.',
      'treatmentPlan': 'Insulin injections twice daily',
      'date': '12 January 20XX',
    },
    {
      'condition': 'Hypertension',
      'doctor': 'Dr. James Taylor, M.D.',
      'treatmentPlan': 'Beta-blockers once daily',
      'date': '05 March 20XX',
    },
  ];

  void _navigateToAddMedicalHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MedicalHistoryForm(
          onSave: _addMedicalHistory,
        ),
      ),
    );
  }

  void _navigateToEditMedicalHistory(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MedicalHistoryForm(
          onSave: (data) => _editMedicalHistory(index, data),
          initialData: medicalHistory[index],
        ),
      ),
    );
  }

  void _addMedicalHistory(Map<String, String> data) {
    setState(() {
      medicalHistory.add(data);
    });
  }

  void _editMedicalHistory(int index, Map<String, String> data) {
    setState(() {
      medicalHistory[index] = data;
    });
  }

  void _deleteMedicalHistory(int index) {
    setState(() {
      medicalHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Jane Doe',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Medical History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...medicalHistory.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> history = entry.value;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              history['condition']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _navigateToEditMedicalHistory(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteMedicalHistory(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Doctor: ${history['doctor']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Treatment Plan: ${history['treatmentPlan']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Added on ${history['date']}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _navigateToAddMedicalHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add Medical History'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
