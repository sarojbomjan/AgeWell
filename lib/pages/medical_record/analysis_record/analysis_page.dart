import 'package:elderly_care/pages/medical_record/analysis_record/anaylsis_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/analysis_record_model.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final AnalysisController _controller = AnalysisController();

  final TextEditingController uricAcidController = TextEditingController();
  final TextEditingController bloodSugarController = TextEditingController();
  final TextEditingController cholesterolController = TextEditingController();
  final TextEditingController fastingLevelsController = TextEditingController();
  final TextEditingController ogttController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _updateValues() {
    if (_areFieldsValid()) {
      final analysis = MedicalAnalysis(
        userId: '',
        testDate: dateController.text,
        fastingLevels: fastingLevelsController.text,
        ogtt: ogttController.text,
        hba1c: hba1cController.text,
        uricAcid: uricAcidController.text,
        bloodSugar: bloodSugarController.text,
        cholesterol: cholesterolController.text,
      );

      _controller.addAnalysis(analysis).then((_) {
        _showSnackbar('Analysis data saved successfully!', Colors.green);
      }).catchError((error) {
        _showSnackbar('Failed to save data: $error', Colors.red);
      });
    } else {
      _showSnackbar('Please fill all fields correctly', Colors.orange);
    }
  }

  bool _areFieldsValid() {
    return dateController.text.isNotEmpty &&
        fastingLevelsController.text.isNotEmpty &&
        ogttController.text.isNotEmpty &&
        hba1cController.text.isNotEmpty &&
        uricAcidController.text.isNotEmpty &&
        bloodSugarController.text.isNotEmpty &&
        cholesterolController.text.isNotEmpty;
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    _controller.getUserAnalyses().listen((analyses) {
      if (analyses.isNotEmpty) {
        final analysis = analyses.first;
        setState(() {
          dateController.text = analysis.testDate;
          fastingLevelsController.text = analysis.fastingLevels;
          ogttController.text = analysis.ogtt;
          hba1cController.text = analysis.hba1c;
          uricAcidController.text = analysis.uricAcid;
          bloodSugarController.text = analysis.bloodSugar;
          cholesterolController.text = analysis.cholesterol;
        });
      }
    });
  }

  void _clearValues() {
    setState(() {
      uricAcidController.clear();
      bloodSugarController.clear();
      cholesterolController.clear();
      fastingLevelsController.clear();
      ogttController.clear();
      hba1cController.clear();
      dateController.clear();
    });
  }

  @override
  void dispose() {
    uricAcidController.dispose();
    bloodSugarController.dispose();
    cholesterolController.dispose();
    fastingLevelsController.dispose();
    ogttController.dispose();
    hba1cController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Record'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader('Analysis'),
              _buildSection(
                'Blood Test',
                'A blood test is commonly used to check for various medical conditions. It can assess glucose, cholesterol levels, electrolytes, and liver enzymes, among other factors.',
              ),
              _buildDatePickerField('Test Date', dateController),
              const SizedBox(
                height: 15,
              ),
              _buildSection('GLUCOSE'),
              _buildTextField('Fasting Levels', fastingLevelsController),
              const SizedBox(
                height: 15,
              ),
              _buildTextField(
                  'Oral Glucose Tolerance Test (OGTT)', ogttController),
              const SizedBox(
                height: 15,
              ),
              _buildTextField('Hemoglobin A1c (HbA1c)', hba1cController),
              const SizedBox(
                height: 15,
              ),
              _buildSection('ELECTROLYTES'),
              _buildTextField('Uric Acid', uricAcidController),
              const SizedBox(
                height: 15,
              ),
              _buildSection('LIVER ENZYMES'),
              _buildTextField('Blood Sugar', bloodSugarController),
              const SizedBox(
                height: 15,
              ),
              _buildSection('LIPIDS'),
              _buildTextField('Cholesterol', cholesterolController),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildActionButton('Update', Colors.teal, _updateValues),
                  const SizedBox(width: 20),
                  _buildActionButton('Clear', Colors.red, _clearValues),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSection(String title, [String? description]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(description, style: const TextStyle(fontSize: 16)),
          ),
        const Divider(color: Colors.teal),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(150, 50),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
