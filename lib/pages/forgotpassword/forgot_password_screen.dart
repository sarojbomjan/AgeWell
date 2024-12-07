import "package:elderly_care/pages/forgotpassword/forgot_passoword_mail.dart";
import "package:elderly_care/pages/forgotpassword/forgot_password_phone.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../login/login_page.dart";

class ForgotPasswordPage {
  static Future<dynamic> ForgotPasswordModalShow(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),)),
        builder: (context) => Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Make Selection",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Select one of the option given below to reset your password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ForgotPasswordOptions(
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => ForgotPasswordMail());
                      },
                      btnIcon: Icons.mail_outline_rounded,
                      title: "Email",
                      subTitle: "Reset via Mail Verification"),
                  const SizedBox(
                    height: 20,
                  ),
                  ForgotPasswordOptions(
                      onTap: () {
                        Get.to(() => ForgotPasswordPhone());
                      },
                      btnIcon: Icons.mobile_friendly_rounded,
                      title: "Phone No",
                      subTitle: "Reset via Phone Verification"),
                ],
              ),
            ));
  }
}
