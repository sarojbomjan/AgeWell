import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elderly_care/controller/profile_controller.dart';
import 'package:elderly_care/firebase_options.dart';
import 'package:elderly_care/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'authentication/store_user_details.dart';
import 'authentication/user_authentication.dart';
import 'controller/notification_controller.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "Basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notification channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "Basic_channel_group", channelGroupName: "basic group")
  ]);
  bool isAlllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();

  if (!isAlllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Initialize StoreUser and UserAuthentication once Firebase is initialized
  Get.put(UserAuthentication());
  Get.put(StoreUser());
  Get.put(ProfileController());
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var currentTheme = Get.find<ThemeController>().themeData;

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elderly Care',
        theme: currentTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const CircularProgressIndicator(),
      );
    });
  }
}
