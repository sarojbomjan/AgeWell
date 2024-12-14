import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyContactDialog extends StatefulWidget {
  final Function(String) onContactSaved;

  const EmergencyContactDialog({required this.onContactSaved, Key? key})
      : super(key: key);

  @override
  _EmergencyContactDialogState createState() => _EmergencyContactDialogState();
}

class _EmergencyContactDialogState extends State<EmergencyContactDialog> {
  final TextEditingController _contactController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _userId = FirebaseAuth.instance.currentUser?.uid;
  Future<void> _saveEmergencyContact(String contact) async {
    try {
      if (_userId == null) throw Exception("User ID is null");
      // Update Firestore with new emergency contact
      await _firestore.collection('USERS').doc(_userId).set(
        {
          'emergencyContact': contact,
        },
        SetOptions(merge: true),
      );
      widget.onContactSaved(contact);

      // Fetch updated user data (if needed)
      final userSnapshot =
          await _firestore.collection('USERS').doc(_userId).get();
      final updatedEmergencyContact =
          userSnapshot.data()?['emergencyContact'] ?? '';

      // You can now pass the updated contact or use it for the dialer
      debugPrint("Updated Emergency Contact: $updatedEmergencyContact");

      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Emergency contact saved successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to save emergency contact."),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint("Error saving emergency contact: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Emergency Contact'),
      content: TextField(
        controller: _contactController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Emergency Contact Number',
          hintText: 'Enter a valid phone number',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog without saving
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String contact = _contactController.text.trim();
            if (contact.isNotEmpty) {
              _saveEmergencyContact(contact);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
