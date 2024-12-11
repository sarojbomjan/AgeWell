// import 'package:flutter/material.dart';

// class RegisterUserForm extends StatefulWidget {
//   final Function(Map<String, String>) onRegisterUser;

//   const RegisterUserForm({Key? key, required this.onRegisterUser})
//       : super(key: key);

//   @override
//   _RegisterUserFormState createState() => _RegisterUserFormState();
// }

// class _RegisterUserFormState extends State<RegisterUserForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   String _selectedRole = 'Caregiver';

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       widget.onRegisterUser({
//         'email': _emailController.text,
//         'password': _passwordController.text,
//         'role': _selectedRole,
//         'phone': _phoneController.text,
//         'address': _addressController.text,
//       });
//       // Clear form after submission
//       _formKey.currentState!.reset();
//       _emailController.clear();
//       _passwordController.clear();
//       _phoneController.clear();
//       _addressController.clear();
//       setState(() {
//         _selectedRole = 'Caregiver';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Register New User',
//                 style: Theme.of(context).textTheme.head,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                       .hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters long';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 decoration: const InputDecoration(
//                   labelText: 'Role',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: [
//                   'Caregiver',
//                   'Elderly User',
//                   'Family Member',
//                   'Emergency Contact'
//                 ].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedRole = newValue!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a phone number';
//                   }
//                   if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
//                     return 'Please enter a valid phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(
//                   labelText: 'Address',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: const Text('Register User'),
//                 style: ElevatedButton.styleFrom(
//                   primary: AdminTheme.primaryColor,
//                   onPrimary: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
