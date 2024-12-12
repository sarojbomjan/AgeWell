import 'package:flutter/material.dart';

class MedicalHistoryForm extends StatefulWidget {
  const MedicalHistoryForm({super.key});

  @override
  State<MedicalHistoryForm> createState() => _MedicalHistoryFormState();
}

class _MedicalHistoryFormState extends State<MedicalHistoryForm> {
  String selectedDoctor = 'Dr. Emma Hall, M.D.';
  bool isOtherSelected = false;
  TextEditingController otherDoctorController = TextEditingController();
  TextEditingController inControlController = TextEditingController();
  TextEditingController treatmentPlanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inControlController.text = 'Paroxysmal Tachycardia\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
    treatmentPlanController.text = 'Lorem ipsum dolor 5mg (Morning)\nLorem ipsum dolor 15mg (Night)';
  }

  @override
  void dispose() {
    otherDoctorController.dispose();
    inControlController.dispose();
    treatmentPlanController.dispose();
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
              const Text(
                'Medical History',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'In Control',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: inControlController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Treatment Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: treatmentPlanController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Doctor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (!isOtherSelected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedDoctor,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == 'Other') {
                          isOtherSelected = true;
                          selectedDoctor = '';
                        } else {
                          selectedDoctor = newValue!;
                          isOtherSelected = false;
                        }
                      });
                    },
                    items: <String>[
                      'Dr. Emma Hall, M.D.',
                      'Dr. James Taylor, M.D.',
                      'Other',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    dropdownColor: Colors.teal,
                    iconEnabledColor: Colors.white,
                    underline: Container(),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: otherDoctorController,
                      decoration: const InputDecoration(
                        hintText: 'Enter doctor name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDoctor = otherDoctorController.text;
                          isOtherSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Save Doctor', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Text(
                'Upload Medical Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Placeholder for image picker functionality
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: Text('Tap to upload image', style: TextStyle(fontSize: 16))),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle save button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size.fromHeight(50), // Make button full width
                ),
                child: const Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
