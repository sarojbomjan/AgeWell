import 'package:elderly_care/controller/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreeen extends StatelessWidget {
  const OTPScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    var otp;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OTP",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 80),
            ),
            Text(
              "VERIFICATION",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              "Enter the verification code send at " + "@gmail.com",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                otp = code;
                OTPController.instance.verifyOTP(otp);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      OTPController.instance.verifyOTP(otp);
                    },
                    child: const Text("Next")))
          ],
        ),
      ),
    );
  }
}
