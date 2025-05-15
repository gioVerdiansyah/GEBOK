import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/constants/notification_setting_constant.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);

    // Initialize with the callback for when a notification is tapped
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );
  }

  // Method to handle notification tap in foreground
  static Future<void> _onDidReceiveNotificationResponse(NotificationResponse response) async {
    if (response.payload != null) {
      Map<String, dynamic> payload = jsonDecode(response.payload!);
      debugPrint('Notification payload: $payload');

      if (payload['filePath'] != null) {
        OpenFile.open(payload['filePath']);
      }
    }
  }

  // Method to handle background notification tap
  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {
    // Handle the action here, this will run in a background isolate
    debugPrint("Background notification tapped: ${response.payload}");
  }

  // Method to show notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    dynamic payload,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      NotificationSettingConstant.channelId,
      NotificationSettingConstant.channelName,
      channelDescription: NotificationSettingConstant.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_launcher',
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: const DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> downloadNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    String? payload,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      NotificationSettingConstant.channelId,
      NotificationSettingConstant.channelName,
      channelDescription: NotificationSettingConstant.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails, iOS: const DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static Future<void> cancel({required int id}) async {
    return await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    return await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
