import 'package:flutter/material.dart';

void showAddActivityBottomSheet(BuildContext context) {
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
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Time',
                    icon: Icons.access_time,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildCategorySelector(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add activity logic here
                        Navigator.pop(context);
                      },
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
}

Widget _buildTextField({
  required String label,
  required IconData icon,
  int maxLines = 1,
}) {
  return TextField(
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

Widget _buildCategorySelector() {
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
          _buildCategoryChip('Medical', Icons.medical_services, Colors.blue),
          _buildCategoryChip('Exercise', Icons.fitness_center, Colors.green),
          _buildCategoryChip('Medication', Icons.medication, Colors.orange),
          _buildCategoryChip('Other', Icons.more_horiz, Colors.purple),
        ],
      ),
    ],
  );
}

Widget _buildCategoryChip(String label, IconData icon, Color color) {
  return FilterChip(
    label: Text(label),
    avatar: Icon(icon, color: color),
    backgroundColor: color.withOpacity(0.1),
    selectedColor: color.withOpacity(0.3),
    checkmarkColor: color,
    selected: false,
    onSelected: (bool selected) {
      // Handle category selection
    },
  );
}
