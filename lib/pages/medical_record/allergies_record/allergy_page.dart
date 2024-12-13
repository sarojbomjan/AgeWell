import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class AllergyPage extends StatefulWidget {
  const AllergyPage({super.key});

  @override
  State<AllergyPage> createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {
  final List<Map<String, String>> allergies = [
    {
      'name': 'Insulin',
      'symptoms': 'Skin Symptoms: redness, itching and swelling at injection site.',
      'date': '10 February 20XX',
    },
    {
      'name': 'Codeine',
      'symptoms': 'Respiratory Symptoms: Wheezing, difficulty breathing.',
      'date': '06 June 20XX',
    },
    {
      'name': 'Pollen',
      'symptoms': 'Respiratory Symptoms: Sneezing, runny nose, nasal congestion.',
      'date': '20 October 20XX',
    },
    {
      'name': 'Latex',
      'symptoms': 'Skin Symptoms: Itching, redness, rash.',
      'date': '20 October 20XX',
    },
  ];

  final TextEditingController _allergyNameController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  void _showAddAllergyDialog() {
    _allergyNameController.clear();
    _symptomsController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Allergy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _allergyNameController,
                decoration: const InputDecoration(labelText: 'Allergy Name'),
              ),
              TextField(
                controller: _symptomsController,
                decoration: const InputDecoration(labelText: 'Symptoms'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Get the current date in the desired format
                String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

                setState(() {
                  allergies.add({
                    'name': _allergyNameController.text,
                    'symptoms': _symptomsController.text,
                    'date': formattedDate,
                  });
                  _allergyNameController.clear();
                  _symptomsController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditAllergyDialog(int index) {
    _allergyNameController.text = allergies[index]['name']!;
    _symptomsController.text = allergies[index]['symptoms']!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Allergy'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _allergyNameController,
                decoration: const InputDecoration(labelText: 'Allergy Name'),
              ),
              TextField(
                controller: _symptomsController,
                decoration: const InputDecoration(labelText: 'Symptoms'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  allergies[index]['name'] = _allergyNameController.text;
                  allergies[index]['symptoms'] = _symptomsController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAllergy(int index) {
    setState(() {
      allergies.removeAt(index);
    });
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
              const Center(
                child: Text(
                  'Jane Doe',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Gender: Female', style: TextStyle(fontSize: 16)),
                  Text('Blood Type: AB +', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Age: 26 Years', style: TextStyle(fontSize: 16)),
                  Text('Weight: 65 Kg', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Allergies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                'And Adverse Reactions',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ...allergies.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> allergy = entry.value;
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
                            Flexible(
                              child: Text(
                                allergy['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.teal),
                                  onPressed: () => _showEditAllergyDialog(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteAllergy(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          allergy['symptoms']!,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Added Manually ${allergy['date']}',
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
                  onPressed: _showAddAllergyDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add More'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
