import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/core/network/api_client.dart';
import 'package:book_shelf/app.dart';
import 'package:book_shelf/src/core/system/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id_ID';
  await initializeDateFormatting('id_ID', null);

  await NotificationService.initialize();
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await ApiClient.init();
  setupDependencies(navigatorKey: navigatorKey);

  runApp(App(navigatorKey: navigatorKey,));
}