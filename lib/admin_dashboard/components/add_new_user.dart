import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserModal extends StatefulWidget {
  const AddUserModal({Key? key}) : super(key: key);

  @override
  _AddUserModalState createState() => _AddUserModalState();
}

class _AddUserModalState extends State<AddUserModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialistController = TextEditingController();
  final _ratingsController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _reviewsController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  final _languagesController = TextEditingController();
  final _workHoursController = TextEditingController();

  String _selectedRole = 'Caregiver';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _specialistController.dispose();
    _ratingsController.dispose();
    _availabilityController.dispose();
    _reviewsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? currentUser = FirebaseAuth.instance.currentUser;

        final String adminEmail = currentUser!.email!;
        final String? adminPassword = await _getAdminPassword();

        UserCredential newUserCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: '12345678',
        );

        // Get the UID of the new user
        String newUserId = newUserCredential.user!.uid;

        final userData = {
          'FullName': _nameController.text,
          'Email': _emailController.text,
          'Address': _addressController.text,
          'Phone': _phoneController.text,
          'Role': _selectedRole,
          'AuthUID': newUserId,
        };

        if (_selectedRole == 'Doctor') {
          userData.addAll({
            'Specialist': _specialistController.text,
            'Ratings': _ratingsController.text,
            'Availability': _availabilityController.text,
            'Reviews': _reviewsController.text,
          });
        }

        if (_selectedRole == 'Caregiver') {
          userData.addAll({
            'Experience': _experienceController.text,
            'Skills': _skillsController.text,
            'Languages': _languagesController.text,
            'WorkHours': _workHoursController.text,
          });
        }

        // Store the user data in Firestore with the UID as the document ID
        await FirebaseFirestore.instance
            .collection('USERS')
            .doc(newUserId)
            .set(userData);

        // Log the admin back in to restore their session
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword!,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!')),
        );
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add user. Try again.')),
        );
      }
    }
  }

  Future<String?> _getAdminPassword() async {
    return '12345678';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New User',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Caregiver', 'Family Member', 'Doctor']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                ),
                if (_selectedRole == 'Doctor') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specialistController,
                    decoration: const InputDecoration(
                      labelText: 'Specialist',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a specialty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ratingsController,
                    decoration: const InputDecoration(
                      labelText: 'Ratings',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a rating';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _availabilityController,
                    decoration: const InputDecoration(
                      labelText: 'Availability',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter availability details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reviewsController,
                    decoration: const InputDecoration(
                      labelText: 'Reviews',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter reviews';
                      }
                      return null;
                    },
                  ),
                ],
                if (_selectedRole == 'Caregiver') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Years of Experience',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter years of experience';
                      }
                      if (int.tryParse(value) == null || int.parse(value) < 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _skillsController,
                    decoration: const InputDecoration(
                      labelText: 'Skills (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter at least one skill';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _languagesController,
                    decoration: const InputDecoration(
                      labelText: 'Languages Spoken (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter at least one language';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _workHoursController,
                    decoration: const InputDecoration(
                      labelText: 'Preferred Work Hours',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter preferred work hours';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Add User'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
