import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/core/network/api_client.dart';
import 'package:book_shelf/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id_ID';
  await initializeDateFormatting('id_ID', null);
  await ApiClient.init();
  setupDependencies(navigatorKey: navigatorKey);

  runApp(App(navigatorKey: navigatorKey,));
}