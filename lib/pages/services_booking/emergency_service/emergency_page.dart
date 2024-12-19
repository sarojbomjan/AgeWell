import 'package:flutter/material.dart';

void main() {
  runApp(const EmergencyApp());
}

class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Numbers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmergencyPage(),
    );
  }
}

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emergencyNumbers = [
      {'service': 'Nepal Police', 'number': '100', 'charge': 'Free'},
      {'service': 'Fire Support', 'number': '101', 'charge': 'Free'},
      {'service': 'Ambulance Support', 'number': '102', 'charge': 'Free'},
      {'service': 'Traffic Support', 'number': '103', 'charge': 'Free'},
      {'service': 'Child Helpline', 'number': '104', 'charge': 'Free'},
      {
        'service': 'CIAA (Commission for the Investigation of Abuse of Authority)',
        'number': '107',
        'charge': 'Free'
      },
      {'service': 'Missing Child Response', 'number': '1098', 'charge': 'Free'},
      {'service': 'Armed Police Force Support', 'number': '1114', 'charge': 'Free'},
      {'service': 'Women Helpline', 'number': '1145', 'charge': 'Free'},
      {'service': 'NEA Helpline', 'number': '1149', 'charge': 'Free'},
      {'service': 'Patan Mental Hospital', 'number': '1166', 'charge': 'Free'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Numbers'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: emergencyNumbers.length,
        itemBuilder: (context, index) {
          final emergency = emergencyNumbers[index];
          return ListTile(
            title: Text(emergency['service']!, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text('Number: ${emergency['number']}', style: TextStyle(color: Colors.red),),
            trailing: Text(emergency['charge']!),
          );
        },
      ),
    );
  }
}
