import 'package:elderly_care/pages/medical_record/allergies_record/allergy_page.dart';
import 'package:elderly_care/pages/medical_record/analysis_record/analysis_page.dart';
import 'package:elderly_care/pages/medical_record/medical_history_record/medical_history_page.dart';
import 'package:elderly_care/pages/medical_record/personal_record_page.dart';
import 'package:elderly_care/pages/medical_record/vaccination_record/vaccination_page.dart';
import 'package:flutter/material.dart';

class MedicalRecordsPage extends StatelessWidget {
  const MedicalRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Medical Record'),
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
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalRecordPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Update Personal Record'),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoText('Gender:', 'Male'),
                _buildInfoText('Blood Type:', 'AB +'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoText('Age:', '46 Years'),
                _buildInfoText('Weight:', '65 Kg'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildMenuButton('Allergies', Icons.medical_services, context),
                  _buildMenuButton('Analysis', Icons.analytics, context),
                  _buildMenuButton('Vaccinations', Icons.vaccines, context),
                  _buildMenuButton('Medical History', Icons.history, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String title, String info) {
    return RichText(
      text: TextSpan(
        text: '$title ',
        style: TextStyle(color: Colors.black, fontSize: 16),
        children: <TextSpan>[
          TextSpan(
            text: info,
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, IconData icon, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'Allergies':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllergyPage(),
                ),
              );
              break;
            case 'Analysis':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalysisPage(),
                ),
              );
              break;
            case 'Vaccinations':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VaccinationPage(),
                ),
              );
              break;
            case 'Medical History':
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicalHistoryPage(),
                ),
              );
              break;
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.teal,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
