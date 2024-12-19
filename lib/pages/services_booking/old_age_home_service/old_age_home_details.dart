import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OldAgeHomeDetails extends StatefulWidget {
  const OldAgeHomeDetails({Key? key}) : super(key: key);

  @override
  State<OldAgeHomeDetails> createState() => _OldAgeHomeDetailsState();
}

class _OldAgeHomeDetailsState extends State<OldAgeHomeDetails> {
  final TextEditingController _visitDateController = TextEditingController();
  final TextEditingController _visitTimeController = TextEditingController();
  final TextEditingController _visitorNameController = TextEditingController();
  final TextEditingController _visitorContactController = TextEditingController();
  final TextEditingController _specialNotesController = TextEditingController();

  Future<void> _selectVisitDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _visitDateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectVisitTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _visitTimeController.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Old Age Home Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with an actual image URL
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sunshine Old Age Home',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        '123-456-7890',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.email, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'contact@sunshineoldagehome.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        '123 Sunshine Street, Cityville',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Book a Visit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _visitDateController,
              decoration: InputDecoration(
                labelText: 'Select Visit Date',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectVisitDate(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _visitTimeController,
              decoration: InputDecoration(
                labelText: 'Select Visit Time',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () => _selectVisitTime(context),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _visitorNameController,
              decoration: const InputDecoration(
                labelText: 'Visitor Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _visitorContactController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _specialNotesController,
              decoration: const InputDecoration(
                labelText: 'Any Special Notes?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add booking logic here
                },
                child: const Text('Book Visit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
