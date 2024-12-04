import 'package:elderly_care/authentication/user_authentication.dart';
import 'package:elderly_care/pages/home_page.dart';
import 'package:get/get.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await UserAuthentication.instance.verifyOTP(otp);
    isVerified ? Get.offAll(const HomePage()) : Get.back();
  }
}
