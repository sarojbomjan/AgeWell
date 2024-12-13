import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VaccinationPage extends StatefulWidget {
  const VaccinationPage({super.key});

  @override
  State<VaccinationPage> createState() => _VaccinationPageState();
}

class _VaccinationPageState extends State<VaccinationPage> {
  final List<Map<String, String>> immunisationHistory = [
    {
      'name': 'Covid',
      'dose': 'First Dose',
      'date': '18-08-20',
    },
    {
      'name': 'Tetanus',
      'dose': 'Booster',
      'date': '09-02-19',
    },
    {
      'name': 'Typhus',
      'dose': 'First Dose',
      'date': '22-06-18',
    },
    {
      'name': 'Hepatitis',
      'dose': 'Second Dose',
      'date': '15-09-17',
    },
  ];

  final List<Map<String, String>> nextImmunisations = [
    {
      'name': 'Human Papillomavirus (HPV)',
      'dose': 'Second Dose',
      'date': '18-03-24',
    },
    {
      'name': 'Human Papillomavirus (HPV)',
      'dose': 'Third Dose',
      'date': '',
    },
  ];

  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yy').format(pickedDate);
      });
    }
  }

  void _showAddVaccinationDialog() {
    _vaccineNameController.clear();
    _doseController.clear();
    _dateController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Vaccination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _vaccineNameController,
                decoration: const InputDecoration(labelText: 'Vaccine Name'),
              ),
              TextField(
                controller: _doseController,
                decoration: const InputDecoration(labelText: 'Dose'),
              ),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (DD-MM-YYYY)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
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
                  nextImmunisations.add({
                    'name': _vaccineNameController.text,
                    'dose': _doseController.text,
                    'date': _dateController.text,
                  });
                  _vaccineNameController.clear();
                  _doseController.clear();
                  _dateController.clear();
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

  void _showEditVaccinationDialog(int index) {
    _vaccineNameController.text = nextImmunisations[index]['name']!;
    _doseController.text = nextImmunisations[index]['dose']!;
    _dateController.text = nextImmunisations[index]['date']!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Vaccination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _vaccineNameController,
                decoration: const InputDecoration(labelText: 'Vaccine Name'),
              ),
              TextField(
                controller: _doseController,
                decoration: const InputDecoration(labelText: 'Dose'),
              ),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (DD-MM-YYYY)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
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
                  nextImmunisations[index]['name'] = _vaccineNameController.text;
                  nextImmunisations[index]['dose'] = _doseController.text;
                  nextImmunisations[index]['date'] = _dateController.text;
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

  void _deleteVaccination(int index) {
    setState(() {
      nextImmunisations.removeAt(index);
    });
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateFormat('dd-MM-yy').parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
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
                  'Vaccinations',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Immunisation History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: immunisationHistory.map((immunisation) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(immunisation['name']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(immunisation['dose']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_formatDate(immunisation['date']!)),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Next Immunisations Due',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...nextImmunisations.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> immunisation = entry.value;
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    immunisation['name']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    immunisation['dose']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.teal),
                                  onPressed: () => _showEditVaccinationDialog(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteVaccination(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Due Date: ${_formatDate(immunisation['date']!)}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _showAddVaccinationDialog,
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
