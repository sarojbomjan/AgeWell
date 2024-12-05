import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';

class Health extends StatefulWidget {
  const Health({Key? key}) : super(key: key);

  @override
  State<Health> createState() => _Health();
}

class _Health extends State<Health> {
  bool isMeasuring = false;
  int? bpmValue;
  List<HeartRateRecord> records = [];

  @override
  void initState() {
    super.initState();
    _fetchHeartRateRecords(); // Fetch records when the screen loads
  }

  // Toggle measurement state
  void toggleMeasurement() async {
    if (isMeasuring) {
      // Measurement stopped
      if (bpmValue != null) {
        await _saveHeartRateToFirestore(bpmValue!);
      }
    }

    setState(() {
      isMeasuring = !isMeasuring;
      if (!isMeasuring) bpmValue = null; // Reset BPM value on stop
    });
  }

  // Update BPM during measurement
  void updateBPM(int value) {
    setState(() {
      bpmValue = value;
    });
  }

  // Save heart rate data to Firestore
  Future<void> _saveHeartRateToFirestore(int bpm) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to access health data')),
      );
      return;
    }

    try {
      final record = {
        'userId': userId,
        'bpm': bpm,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('HEALTHDATA').add(record);

      // Fetch updated records to display
      _fetchHeartRateRecords();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Heart rate saved successfully!')),
      );
    } catch (e) {
      print("Error saving heart rate: $e");
    }
  }

  // Fetch heart rate records from Firestore
  Future<void> _fetchHeartRateRecords() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to access health data')),
      );
      return;
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('HEALTHDATA')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      print(
          "Number of records fetched: ${querySnapshot.docs.length}"); // Debugging line

      if (querySnapshot.docs.isEmpty) {
        print("No records found for user $userId");
      }

      final fetchedRecords = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print("Document data: $data"); // Debugging line
        return HeartRateRecord(
          data['timestamp']?.toDate() ?? DateTime.now(),
          data['bpm'] as int,
        );
      }).toList();

      setState(() {
        records = fetchedRecords;
      });
      print("Fetched heart rate records: ${records.length}"); // Debugging line
    } catch (e) {
      print("Error fetching heart rate records: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Cover both the camera and flash with your finger',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, size: 60, color: Colors.red),
                const SizedBox(width: 16),
                Text(
                  bpmValue?.toString() ?? '-',
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(width: 8),
                Text(
                  'bpm',
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: toggleMeasurement,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                foregroundColor: theme.colorScheme.primary,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isMeasuring ? 'Stop Measurement' : 'Start Measurement',
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            if (isMeasuring)
              HeartBPMDialog(
                context: context,
                onRawData: (value) {},
                onBPM: updateBPM, // Update BPM during measurement
              ),
            const SizedBox(height: 30),
            if (records.isEmpty)
              Center(
                child: Text(
                  'No heart rate data available.',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 20),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) =>
                    _buildRecordTile(records[index], theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTile(HeartRateRecord record, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 20, color: Colors.purple),
          const SizedBox(width: 8),
          Text(
            '${record.date.year}-${record.date.month}-${record.date.day}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            'HR',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Text(
            '${record.bpm}',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class HeartRateRecord {
  final DateTime date;
  final int bpm;

  HeartRateRecord(this.date, this.bpm);
}
