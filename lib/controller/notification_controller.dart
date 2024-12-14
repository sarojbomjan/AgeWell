import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elderly_care/pages/home/home.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receiveNotification) async {}

// detect everytime new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receiveNotification) async {}

// when user dismisses notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receiveNotification) async {}

  // when user click on notification
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receiveNotification) async {
    Get.offAll(() => HomeScreen());
  }
}
