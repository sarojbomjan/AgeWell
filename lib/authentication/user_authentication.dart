import 'package:elderly_care/authentication/authentication_exception.dart/signup_email_password_failure.dart';
import 'package:elderly_care/pages/home/home_page.dart';
import 'package:elderly_care/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'authentication_exception.dart/login_fauilure.dart';

class UserAuthentication extends GetxController {
  static UserAuthentication get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  /// Checks if the user is already logged in or not
  @override
  void onReady() {
    super.onReady();

    // Initialize firebaseUser to track user changes
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser
        .bindStream(_auth.userChanges()); // Stream for user state changes

    ever(firebaseUser, _setInitialScreen);
  }

  // Navigates based on user state
  _setInitialScreen(User? user) {
    if (user == null) {
      // If no user, go to Welcome screen
      Get.offAll(() => const WelcomeScreen());
    } else {
      // If user is logged in, navigate to HomePage
      Get.offAll(() => const HomePage());
    }
  }

  // phone authentication
  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
        print("Verification ID: $verificationId"); // Debugging
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == "invalid-phone-number") {
          Get.snackbar("Error", "The provided phone number is not valid");
        } else {
          Get.snackbar("Error", "Something went wrong. Try again!");
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: this.verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }

  // Create user with email and password
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // If user creation is successful, navigate to HomePage
      firebaseUser.value != null
          ? Get.offAll(() => const HomePage())
          : Get.to(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException and map it to custom failure message
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      print("FIREBASE AUTH EXCEPTION - ${ex.message}");
      throw ex; // Throw the custom failure for further handling
    } catch (_) {
      // Handle any other unexpected errors
      const ex = SignupWithEmailAndPasswordFailure();
      print("EXCEPTION - ${ex.message}");
      throw ex;
    }
  }
  // Google authentication

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Get.snackbar("Error", "Google Sign-In was cancelled.");
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offAll(() => const HomePage());
      return userCredential;
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed. Please try again.");
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Login user with email and password
  Future<void> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // If login is successful, navigate to HomePage
      Get.offAll(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordFailure.code(e.code);

      // Get.snackbar("Login Error", ex.message,
      //     snackPosition: SnackPosition.BOTTOM);
      throw ex;
    } catch (_) {
      const ex = LoginWithEmailAndPasswordFailure();
      // print("EXCEPTION - ${ex.message}");
      throw ex;
    }
  }

  // Log out function
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();

    // Once logged out, navigate to WelcomeScreen
    Get.offAll(() => const WelcomeScreen());
  }
}
