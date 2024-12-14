import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/authentication/store_user_details.dart';
import 'package:elderly_care/controller/personal_record_controller.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:elderly_care/pages/medical_record/allergies_record/edit_allergy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/allergy_model.dart';
import 'add_allergy_dialog.dart';

class AllergyPage extends StatefulWidget {
  const AllergyPage({super.key});

  @override
  State<AllergyPage> createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {
  final StoreUser _auth = StoreUser();

  List<Allergy> allergies = []; // Use a list of Allergy objects instead of maps

  final TextEditingController _allergyNameController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  Map<String, dynamic>? personalRecord;
  final PersonalRecordController _controller = PersonalRecordController();
  UserModel? userModel;
  bool isLoading = true;

  void _fetchUserDetails() async {
    try {
      // Assuming you have the email from the FirebaseAuth user
      String email = FirebaseAuth.instance.currentUser?.email ?? '';
      if (email.isNotEmpty) {
        UserModel user = await _auth.getUserDetails(email);
        setState(() {
          userModel = user;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show an error message)
      print("Error fetching user details: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchPersonalRecord();
    _fetchAllergies(); // Fetch user details on page load
  }

  // Fetch allergies from Firestore
  void _fetchAllergies() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch allergies from Firestore
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      var snapshot = await FirebaseFirestore.instance
          .collection('ALLERGIES')
          .where('userId', isEqualTo: userId)
          .get();

      // Map the data to Allergy model and update the list
      List<Allergy> fetchedAllergies = snapshot.docs.map((doc) {
        return Allergy(
          id: doc.id,
          name: doc['name'],
          symptoms: doc['symptoms'],
          date: doc['date'],
          userId: doc['userId'],
        );
      }).toList();

      setState(() {
        allergies = fetchedAllergies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching allergies: $e");
    }
  }

  // Fetching the personal record
  void _fetchPersonalRecord() async {
    setState(() {
      isLoading = true;
    });
    var record = await _controller.fetchPersonalRecord(context);

    setState(() {
      personalRecord = record;
      isLoading = false;
    });
  }

  void _showAddAllergyDialog() {
    _allergyNameController.clear();
    _symptomsController.clear();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAllergyDialog(
          allergyNameController: _allergyNameController,
          symptomsController: _symptomsController,
          userId: userId,
          onAddAllergy: (Allergy allergy) {
            // Check if the allergy is already in the list
            bool isDuplicate = allergies.any((existingAllergy) =>
                existingAllergy.name == allergy.name &&
                existingAllergy.symptoms == allergy.symptoms);

            if (!isDuplicate) {
              setState(() {
                allergies.add(allergy);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This allergy already exists')),
              );
            }
          },
        );
      },
    );
  }

  void _showEditAllergyDialog(int index) {
    // Check if allergies[index] is valid
    if (allergies.isNotEmpty && index >= 0 && index < allergies.length) {
      Allergy allergy = allergies[index];

      // Set the allergy details in the controllers
      _allergyNameController.text = allergy.name;
      _symptomsController.text = allergy.symptoms;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditAllergyDialog(
            allergyNameController: _allergyNameController,
            symptomsController: _symptomsController,
            allergyId: allergy.id!,
            onSuccess: () {
              setState(() {
                // Update the allergy in the list
                allergies[index] = Allergy(
                  id: allergy.id,
                  name: _allergyNameController.text,
                  symptoms: _symptomsController.text,
                  date: allergy.date, // Optionally, update the date if needed
                  userId: allergy.userId,
                );
              });
            },
          );
        },
      );
    } else {
      // Handle the case where the allergy at the provided index is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid allergy selection or empty list'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteAllergy(int index) {
    setState(() {
      allergies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Record'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  userModel?.fullName ?? 'No name available',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Age: ${personalRecord?['age'] ?? '-'} Years',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Blood Type: ${personalRecord?['bloodType'] ?? '-'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
              const SizedBox(height: 10),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gender: ${personalRecord?['gender'] ?? '-'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${personalRecord?['weight'] ?? '-'} Kg',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              const Text(
                'Allergies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                'And Adverse Reactions',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ...allergies.asMap().entries.map((entry) {
                int index = entry.key;
                Allergy allergy = entry.value;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                allergy.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.teal),
                                  onPressed: () =>
                                      _showEditAllergyDialog(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteAllergy(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          allergy.symptoms,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Added on ${allergy.date}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _showAddAllergyDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add More'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
