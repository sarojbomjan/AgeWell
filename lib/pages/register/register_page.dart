import 'package:country_picker/country_picker.dart';
import 'package:elderly_care/authentication/validaton/validator.dart';
import 'package:elderly_care/controller/sign_up_controller.dart';
import 'package:elderly_care/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../login/components/my_button.dart';
import '../login/components/my_textfield.dart';
import '../login/components/square_tiles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;

  final controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  Country selectedCountry = Country(
    phoneCode: "977",
    countryCode: "NEP",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Nepal",
    example: "Nepal",
    displayName: "Nepal",
    displayNameNoCountryCode: "NEP",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    //final _controller = Get.put(LoginController());
    // Access the theme
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),

                // Logo
                Icon(
                  Icons.lock,
                  size: 50,
                  color: theme.colorScheme.primary,
                ),

                const SizedBox(height: 40),

                // Page title
                Text(
                  "Create an account",
                  style: textTheme.headlineMedium
                      ?.copyWith(color: theme.colorScheme.onBackground),
                ),

                const SizedBox(height: 30),

                // name TextField
                MyTextfield(
                  controller: controller.fullName,
                  hintText: 'Full Name',
                  labelText: "Full Name",
                  obscureText: false,
                  isPasswordField: false,
                  prefixIcon: Icons.person,
                ),

                const SizedBox(height: 30),
                // Email TextField
                MyTextfield(
                  controller: controller.email,
                  hintText: 'Email',
                  labelText: "Email",
                  obscureText: false,
                  isPasswordField: false,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) => EmailValidator.validate(value ?? ""),
                ),

                const SizedBox(height: 30),

                // phone TextField
                MyTextfield(
                  controller: controller.phoneNo,
                  hintText: 'Phone Number',
                  labelText: "Phone Number",
                  obscureText: false,
                  isPasswordField: false,
                  prefixIcon: Icons.phone_android_outlined,
                  validator: (value) => PhoneValidator.validate(value ?? ""),
                ),

                // Phone Number TextField with Country Code and Flag
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: TextField(
                //     controller: controller.phoneNo,
                //     decoration: InputDecoration(
                //       hintText: 'Phone Number',
                //       filled: true,
                //       fillColor: theme.colorScheme.surface,
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: theme.colorScheme.outline,
                //         ),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: theme.colorScheme.primary,
                //         ),
                //       ),
                //       prefixIcon: Container(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal:
                //                 10.0), // Reduced padding to match other fields
                //         child: InkWell(
                //           onTap: () {
                //             showCountryPicker(
                //               context: context,
                //               countryListTheme: const CountryListThemeData(
                //                 bottomSheetHeight:
                //                     500, // Adjust bottom sheet height as needed
                //               ),
                //               onSelect: (value) {
                //                 setState(() {
                //                   selectedCountry =
                //                       value; // Update selected country
                //                 });
                //               },
                //             );
                //           },
                //           child: Row(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Text(
                //                 "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                //                 style: Theme.of(context)
                //                     .textTheme
                //                     .bodyMedium
                //                     ?.copyWith(
                //                       color: theme.colorScheme
                //                           .onSurface, // Make text color consistent
                //                       fontSize:
                //                           16, // Adjust font size to match other text fields
                //                     ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(height: 30),

                // Address TextField
                MyTextfield(
                  controller: controller.address,
                  hintText: 'Address',
                  labelText: "Address",
                  obscureText: false,
                  isPasswordField: false,
                  prefixIcon: Icons.location_city_outlined,
                ),

                const SizedBox(height: 30),
                // Password TextField
                MyTextfield(
                  controller: controller.password,
                  hintText: 'Password',
                  labelText: "Password",
                  obscureText: true,
                  isPasswordField: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (value) => PasswordValidator.validate(value ?? ""),
                ),

                const SizedBox(height: 30),

                // Sign Up button
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return MyButton(
                      text: "Sign Up",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Register user with email and password
                            await controller.registerUser();

                            // Clear text fields after successful registration
                            controller.fullName.clear();
                            controller.email.clear();
                            controller.phoneNo.clear();
                            controller.address.clear();
                            controller.password.clear();

                            // Show success message or navigate
                            Get.snackbar(
                              "Success",
                              "Account created successfully!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            // Handle errors (e.g., Firebase or validation errors)
                            Get.snackbar(
                              "Error",
                              e.toString(),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                    );
                  }
                }),

                const SizedBox(height: 40),

                // Divider with text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Or continue with",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: theme.colorScheme.onSurface),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 45),

                //  Social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => SquareTile(
                          imagePath: 'lib/images/google.png',
                          onTap: () {
                            LoginController.instance.googleSignIn();
                          },
                          isLoading:
                              LoginController.instance.isGoogleLoading.value,
                        )),
                    const SizedBox(width: 20),
                    Obx(() => SquareTile(
                          imagePath: 'lib/images/facebook.jpg',
                          onTap: () {
                            // LoginController.instance.facebookSignIn();
                          },
                          isLoading:
                              LoginController.instance.isFacebookLoading.value,
                        )),
                  ],
                ),

                const SizedBox(height: 40),

                // Navigate to Login Page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Login now",
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
