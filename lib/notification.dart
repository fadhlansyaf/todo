import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
  const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    channelDescription: 'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,

  );

  final IOSNotificationDetails _iosNotificationDetails = const IOSNotificationDetails(
    // presentAlert: true,
    // presentBadge: true,
    // presentSound: true,
    subtitle: 'Test',
  );

  Future<void> showNotifications(String id, String title) async {
    await flutterLocalNotificationsPlugin.show(
      int.parse(id),
      title,
      null,
      NotificationDetails(android: _androidNotificationDetails, iOS: _iosNotificationDetails),
      payload: 'test',
    );
  }

  Future<void> scheduleNotifications(String title, String body, DateTime date, int id) async {
    final timezone = await FlutterNativeTimezone.getLocalTimezone();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime(tz.getLocation(timezone), date.year, date.month, date.day, date.hour, date.minute),
        NotificationDetails(android: _androidNotificationDetails, iOS: _iosNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }
  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

void selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  // navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => const NewsPage(),));
  // await Navigator.push(
  //   context,
  //   MaterialPageRoute<void>(builder: (context) => NewsPage()),
  // );
}