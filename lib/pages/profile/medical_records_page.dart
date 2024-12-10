import 'package:flutter/material.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  List<String> _medicalRecords = [];
  TextEditingController _recordController = TextEditingController();

  void _addRecord() {
    setState(() {
      if (_recordController.text.isNotEmpty){
        _medicalRecords.add(_recordController.text);
        _recordController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Records"),
      ),
      body: Padding(padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _recordController,
            decoration: InputDecoration(
              labelText: 'Enter Medical Record',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: _addRecord,
            child: Text('Add Record'),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: _medicalRecords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_medicalRecords[index]),
                  );
                })
          ),],
      ),),
    );
  }
}
