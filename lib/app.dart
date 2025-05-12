import 'package:book_shelf/src/core/system/app_theme.dart';
import 'package:book_shelf/src/features/auth/presentations/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const App({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: const Locale('id', 'ID'),
      title: 'Book Shelf',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkNavigationBarTheme(),
      home: const OnboardingScreen(),
    );
  }
}