import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/allergy_model.dart';

class AddAllergyDialog extends StatefulWidget {
  final TextEditingController allergyNameController;
  final TextEditingController symptomsController;
  final Function(Allergy allergy) onAddAllergy;
  final String? userId;

  const AddAllergyDialog({
    Key? key,
    required this.allergyNameController,
    required this.symptomsController,
    required this.onAddAllergy,
    required this.userId,
  }) : super(key: key);

  @override
  State<AddAllergyDialog> createState() => _AddAllergyDialogState();
}

class _AddAllergyDialogState extends State<AddAllergyDialog> {
  Future<void> _saveToFirestore(Allergy allergy) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('ALLERGIES')
          .add(allergy.toFirestore());

      // Update the `id` property of the Allergy instance after it's saved
      allergy.id = docRef.id;

      // Update locally
      widget.onAddAllergy(allergy);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Allergy added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add allergy: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Allergy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.allergyNameController,
            decoration: const InputDecoration(labelText: 'Allergy Name'),
          ),
          TextField(
            controller: widget.symptomsController,
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
          onPressed: () async {
            if (widget.userId == null) {
              print('Error: User not logged in');
              return;
            }

            String formattedDate =
                DateFormat('dd MMMM yyyy').format(DateTime.now());

            Allergy allergy = Allergy(
              name: widget.allergyNameController.text.trim(),
              symptoms: widget.symptomsController.text.trim(),
              date: formattedDate,
              userId: widget.userId!,
            );

            widget.onAddAllergy(allergy);

            await _saveToFirestore(allergy);

            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
