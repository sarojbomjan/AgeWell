import 'package:elderly_care/pages/settings/settings_page.dart';
import 'package:elderly_care/pages/medical_record/medical_records_page.dart';
import 'package:elderly_care/pages/profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:elderly_care/controller/profile_controller.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:elderly_care/pages/profile/update_profile.dart';
import 'package:elderly_care/pages/Payment/esewa_payment_page.dart';
import 'package:elderly_care/pages/qrcodes/generate_qr_code.dart';
import '../../authentication/user_authentication.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());

    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: profileController.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong. Please try again later.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            UserModel userData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context, userData),
                  const SizedBox(height: 20),
                  _buildProfileMenu(context, userData),
                ],
              ),
            );
          } else {
            return const Center(
              child:
                  Text('User data not found', style: TextStyle(fontSize: 16)),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel userData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF6750A4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage("lib/images/user.webp"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LineAwesomeIcons.edit,
                      size: 20, color: Color(0xFF6750A4)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            userData.fullName,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text("Edit Profile"),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, UserModel userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ProfileMenuWidget(
            title: "Settings",
            icon: LineAwesomeIcons.cog_solid,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
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
            },
          ),
          ProfileMenuWidget(
            title: "Payment",
            icon: LineAwesomeIcons.wallet_solid,
            onPress: () {
              EsewaPaymentPage().esewapayment();
            },
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
              Get.to(() => GenerateQrCode(userData: userData));
            },
          ),
          const Divider(),
          ProfileMenuWidget(
            title: "Logout",
            icon: LineAwesomeIcons.sign_out_alt_solid,
            textColor: Colors.red,
            endIcon: false,
            onPress: () {
              UserAuthentication.instance.logout();
            },
          ),
        ],
      ),
    );
  }
}
