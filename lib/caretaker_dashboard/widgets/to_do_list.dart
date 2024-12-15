// lib/caretaker_dashboard/widgets/to_do_list_modal.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showToDoBottomSheet(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TimeOfDay? selectedTime;
  String selectedCategory = "Other"; // Default category

  void saveActivity() async {
    try {
      if (selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a time.")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('ACTIVITIES').add({
        'name': nameController.text,
        'time':
            selectedTime?.format(context), // Save time as a formatted string
        'description': descriptionController.text,
        'category': selectedCategory,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser?.uid
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Activity added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add activity: $e")),
      );
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Activity',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        label: 'Activity Name',
                        icon: Icons.edit,
                        controller: nameController,
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(context, selectedTime, (TimeOfDay time) {
                        selectedTime = time;
                      }),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Description',
                        icon: Icons.description,
                        controller: descriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      _buildCategorySelector(
                        selectedCategory,
                        (String category) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: saveActivity,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6750A4),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add Activity',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget _buildCategorySelector(
    String selectedCategory, ValueChanged<String> onCategorySelected) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Category',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildCategoryChip('Medical', Icons.medical_services, Colors.blue,
              selectedCategory, onCategorySelected),
          _buildCategoryChip('Exercise', Icons.fitness_center, Colors.green,
              selectedCategory, onCategorySelected),
          _buildCategoryChip('Medication', Icons.medication, Colors.orange,
              selectedCategory, onCategorySelected),
          _buildCategoryChip('Other', Icons.more_horiz, Colors.purple,
              selectedCategory, onCategorySelected),
        ],
      ),
    ],
  );
}

Widget _buildCategoryChip(String label, IconData icon, Color color,
    String selectedCategory, ValueChanged<String> onCategorySelected) {
  return ChoiceChip(
    label: Text(label),
    avatar: Icon(icon, color: color),
    backgroundColor: color.withOpacity(0.1),
    selectedColor: color.withOpacity(0.3),
    labelStyle: TextStyle(
      color: selectedCategory == label ? Colors.white : color,
      fontWeight:
          selectedCategory == label ? FontWeight.bold : FontWeight.normal,
    ),
    selected: selectedCategory == label,
    onSelected: (bool selected) {
      onCategorySelected(label);
    },
  );
}

Widget _buildTimePicker(
  BuildContext context,
  TimeOfDay? selectedTime,
  ValueChanged<TimeOfDay> onTimePicked,
) {
  return GestureDetector(
    onTap: () async {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
      if (time != null) {
        onTimePicked(time);
      }
    },
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.access_time, color: Color(0xFF6750A4)),
      title: Text(
        selectedTime?.format(context) ?? 'Select Time',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    ),
  );
}

Widget _buildTextField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF6750A4)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    ),
  );
}
