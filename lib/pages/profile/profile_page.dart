import 'package:elderly_care/pages/profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:elderly_care/controller/profile_controller.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:elderly_care/pages/profile/update_profile.dart';
import 'package:elderly_care/pages/qrcodes/generate_qr_code.dart';
import 'package:elderly_care/constants/color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, profileController),
            const SizedBox(height: 20),
            _buildProfileMenu(context, profileController),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, ProfileController profileController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: FutureBuilder<UserModel?>(
        future: profileController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white));
          } else if (snapshot.hasData) {
            UserModel userData = snapshot.data!;
            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("lib/images/google.png"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(LineAwesomeIcons.edit,
                            size: 20, color: Color(0xFF6750A4)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  userData.fullName,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  userData.email,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfile()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF6750A4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                  ),
                  child: const Text("Edit Profile"),
                ),
              ],
            );
          } else {
            return const Text('User data not found',
                style: TextStyle(color: Colors.white));
          }
        },
      ),
    );
  }

  Widget _buildProfileMenu(
      BuildContext context, ProfileController profileController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder<UserModel?>(
        future: profileController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            UserModel userData = snapshot.data!;
            return Column(
              children: [
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
                  title: "Privacy and Policies",
                  icon: LineAwesomeIcons.info_circle_solid,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                  title: "Generate QR Code",
                  icon: LineAwesomeIcons.qrcode_solid,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GenerateQrCode(userData: userData),
                      ),
                    );
                  },
                ),
                const Divider(),
                ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {},
                ),
              ],
            );
          } else {
            return const Text('User data not found');
          }
        },
      ),
    );
  }
}
