import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditAllergyDialog extends StatelessWidget {
  final TextEditingController allergyNameController;
  final TextEditingController symptomsController;
  final String allergyId;
  final VoidCallback onSuccess;

  const EditAllergyDialog({
    super.key,
    required this.allergyNameController,
    required this.symptomsController,
    required this.allergyId,
    required this.onSuccess,
  });

  Future<void> _updateAllergyInFirestore(BuildContext context) async {
    try {
      String updatedName = allergyNameController.text;
      String updatedSymptoms = symptomsController.text;
      String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

      await FirebaseFirestore.instance
          .collection('ALLERGIES')
          .doc(allergyId)
          .update({
        'name': updatedName,
        'symptoms': updatedSymptoms,
        'date': formattedDate, // Update the date if needed
      });

      onSuccess();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Allergy updated successfully')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update allergy')),
      );
      print('Error updating allergy: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Allergy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: allergyNameController,
            decoration: const InputDecoration(labelText: 'Allergy Name'),
          ),
          TextField(
            controller: symptomsController,
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
          onPressed: () => _updateAllergyInFirestore(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
