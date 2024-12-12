import 'package:flutter/material.dart';

class PersonalRecordPage extends StatefulWidget {
  const PersonalRecordPage({super.key});

  @override
  State<PersonalRecordPage> createState() => _PersonalRecordPageState();
}

class _PersonalRecordPageState extends State<PersonalRecordPage> {
  String gender = 'Female';
  double age = 26;
  double weight = 75;
  double height = 178;
  String bloodType = 'AB +';
  List<String> bloodTypes = ['A +', 'A -', 'B +', 'B -', 'AB +', 'AB -', 'O +', 'O -'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Record'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What is your gender',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderButton('Male'),
                  _buildGenderButton('Female'),
                  _buildGenderButton('Other'),
                ],
              ),
              SizedBox(height: 20),
              _buildSlider('How old are you', age, 0, 100, (value) {
                setState(() {
                  age = value;
                });
              }),
              _buildSlider('What is your weight', weight, 0, 200, (value) {
                setState(() {
                  weight = value;
                });
              }),
              _buildSlider('What is your height', height, 0, 200, (value) {
                setState(() {
                  height = value;
                });
              }),
              SizedBox(height: 20),
              Text(
                'What is your blood type',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                  width: 200, // Set the desired width
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: bloodType,
                      onChanged: (String? newValue) {
                        setState(() {
                          bloodType = newValue!;
                        });
                      },
                      items: bloodTypes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.teal,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String genderOption) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          gender = genderOption;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: gender == genderOption ? Colors.teal : Colors.white,
        foregroundColor: gender == genderOption ? Colors.white : Colors.teal,
        side: BorderSide(color: Colors.teal),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(genderOption),
    );
  }

  Widget _buildSlider(
      String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.round().toString(),
          activeColor: Colors.teal,
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(min.toStringAsFixed(0)),
              Text(value.round().toString()),
              Text(max.toStringAsFixed(0)),
            ],
          ),
        ),
      ],
    );
  }
}
