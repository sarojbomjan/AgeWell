import 'package:elderly_care/firebase_options.dart';
import 'package:elderly_care/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'authentication/store_user_details.dart';
import 'authentication/user_authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and then initialize other dependencies
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize StoreUser and UserAuthentication once Firebase is initialized
  Get.put(UserAuthentication());
  Get.put(StoreUser());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elderly Care',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      defaultTransition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      home: const CircularProgressIndicator(),
      // home: HomePage(),
    );
  }
}
