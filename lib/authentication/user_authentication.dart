import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderly_care/authentication/authentication_exception.dart/signup_email_password_failure.dart';
import 'package:elderly_care/authentication/store_user_details.dart';
import 'package:elderly_care/models/user_model.dart';
import 'package:elderly_care/pages/home/home.dart';
import 'package:elderly_care/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../admin_dashboard/pages/admin_dashboard.dart';
import 'authentication_exception.dart/login_fauilure.dart';

class UserAuthentication extends GetxController {
  static UserAuthentication get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  //late final Rx<User?> firebaseUser;
  Rx<User?> firebaseUser = Rx<User?>(null);
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

  Future<String?> _getUserRole(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('USERS').doc(uid).get();
      return doc['Role'] as String?;
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500));
    } else {
      final role = await _getUserRole(user.uid);
      if (role == 'admin') {
        Get.offAll(() => const AdminDashboard(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 500));
      } else {
        Get.offAll(() => const HomeScreen(),
            transition: Transition.leftToRight,
            duration: const Duration(milliseconds: 500));
      }
    }
  }

  // _setInitialScreen(User? user) async {
  //   if (user == null) {
  //     Get.offAll(() => const WelcomeScreen());
  //   } else {
  //     final role = await _getUserRole(user.uid);
  //     if (role == 'admin') {
  //       Get.offAll(() => const AdminDashboard());
  //     } else {
  //       Get.offAll(() => const HomeScreen());
  //     }
  //   }
  // }

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
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

  Future<void> createUserWithEmailAndPassword(String email, String password,
      String fullName, String phoneNo, String address) async {
    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Fetch the UID of the newly created user
      final String? uid = userCredential.user?.uid;

      // Create a user model with the fetched UID
      final user = UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        phoneNo: phoneNo,
        address: address,
      );

      // Store the user in Firestore (do this only once)
      if (uid != null) {
        await StoreUser.instance.createUser(user);
      }

      // Navigate to HomePage after successful registration
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException and map it to custom failure message
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      print("FIREBASE AUTH EXCEPTION - ${ex.message}");
      throw ex;
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
      Get.offAll(() => const HomeScreen());
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
      Get.offAll(() => const HomeScreen());
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
