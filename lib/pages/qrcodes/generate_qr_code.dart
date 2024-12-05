import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:elderly_care/models/user_model.dart';

class GenerateQrCode extends StatelessWidget {
  final UserModel userData;

  const GenerateQrCode({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    // Prepare the data for the QR code
    String qrData = "Name: ${userData.fullName}\n"
        "Address: ${userData.address}\n"
        "Email: ${userData.email}\n"
        "Phone: ${userData.phoneNo}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrettyQrView.data(
              data: qrData,
              // size: 250.0,
              // roundEdges: true,
              // elementColor: Colors.black,
              // errorCorrectLevel: "M",
            ),
            const SizedBox(height: 20),
            Text("Scan this QR code to view user details"),
          ],
        ),
      ),
    );
  }
}
