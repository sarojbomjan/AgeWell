import 'package:elderly_care/constants/color.dart';
import 'package:elderly_care/controller/profile_controller.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:elderly_care/pages/profile/medical_records_page.dart';
import 'package:elderly_care/pages/profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user data from Firestore if needed (e.g., full name)
    final profileController = Get.put(ProfileController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            Image(image: AssetImage("lib/images/google.png"))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: const Icon(
                        LineAwesomeIcons.edit,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // Display the current user's name and email
              FutureBuilder<UserModel?>(
                future: profileController.getUserData(), // Fetch user data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    UserModel userData = snapshot.data!;
                    return Column(
                      children: [
                        Text(
                          userData.fullName, // Display the user's full name
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          userData.email, // Display the current user's email
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    );
                  } else {
                    return const Text('User data not found');
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const UpdateProfile());
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
                height: 30,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),

              //menu section
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog_solid,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "User Management",
                icon: LineAwesomeIcons.user_check_solid,
                onPress: () {},
              ),
              ProfileMenuWidget(
                title: "Medical Records",
                icon: LineAwesomeIcons.clinic_medical_solid,
                onPress: () {
                  Get.to(() => const MedicalRecordsPage());
                  },),
              ProfileMenuWidget(
                title: "Privacy and Policies",
                icon: LineAwesomeIcons.info_circle_solid,
                onPress: () {},
              ),
              const Divider(),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.sign_out_alt_solid,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {},
              ),
              //ProfileMenuWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.endIcon = true,
      this.textColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: accentColor.withOpacity(0.1)),
        child: Icon(
          icon,
          color: accentColor,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                LineAwesomeIcons.angle_right_solid,
                size: 18,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
