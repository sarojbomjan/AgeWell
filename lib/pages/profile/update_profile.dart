import 'package:elderly_care/controller/profile_controller.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:elderly_care/pages/profile/delete_confimation_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../login/components/my_textfield.dart';
import '../../constants/color.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
            future: controller.getUserData(), // Fetch user data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  controller.fullname.text = userData.fullName;
                  controller.email.text = userData.email;
                  controller.phoneNo.text = userData.phoneNo;
                  controller.address.text = userData.address;
                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                    image:
                                        AssetImage("lib/images/google.png"))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black,
                              ),
                              child: const Icon(
                                LineAwesomeIcons.camera_retro_solid,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                          child: Column(
                        children: [
                          MyTextfield(
                            controller: controller.fullname,
                            hintText: 'Full Name',
                            labelText: "Full Name",
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyTextfield(
                            controller: controller.email,
                            hintText: 'E-mail',
                            labelText: "Email",
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyTextfield(
                            controller: controller.phoneNo,
                            hintText: 'Phone Number',
                            labelText: "Phone Number",
                            obscureText: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyTextfield(
                            controller: controller.address,
                            hintText: 'Address',
                            labelText: "Address",
                            obscureText: false,
                          ),

                          const SizedBox(height: 30),

                          // submit button

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final userData = await controller
                                    .getUserData(); // Fetch the current user data
                                if (userData != null) {
                                  final updatedUser = UserModel(
                                    uid: userData
                                        .uid, // Ensure the ID from the fetched user is passed
                                    fullName: controller.fullname.text.trim(),
                                    email: controller.email.text.trim(),
                                    phoneNo: controller.phoneNo.text.trim(),
                                    address: controller.address.text.trim(),
                                  );

                                  await controller.updateRecord(updatedUser);

                                  Get.snackbar("Success",
                                      "Profile updated successfully");
                                } else {
                                  Get.snackbar(
                                      "Error", "Unable to fetch user data.");
                                }
                              },
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(color: darkColor),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(TextSpan(
                                  text: "Joined ",
                                  style: TextStyle(fontSize: 12),
                                  children: [
                                    TextSpan(
                                        text: "1 December 2024",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12))
                                  ])),
                              ElevatedButton(
                                onPressed: () {
                                  // Show the delete confirmation dialog
                                  showDeleteConfirmationDialog(
                                      context, controller);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.redAccent.withOpacity(0.1),
                                  foregroundColor: Colors.red,
                                  shape: const StadiumBorder(),
                                  side: BorderSide.none,
                                  elevation: 0,
                                ),
                                child: const Text("Delete"),
                              )
                            ],
                          )
                        ],
                      ))
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
