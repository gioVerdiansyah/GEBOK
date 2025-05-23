import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/core/exceptions/repository_exception.dart';
import 'package:book_shelf/src/core/system/auth_local.dart';
import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';
import 'package:book_shelf/src/features/auth/presentations/blocs/bloc/auth_cubit.dart';
import 'package:book_shelf/src/features/auth/presentations/screens/login_screen.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/widgets/notification/alert_notification.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../shared/constants/asset_constant.dart';
import 'dashboard/guest_dashboard_screen.dart';
import 'dashboard/user_dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardView();
}

class _DashboardView extends State<OnboardingScreen> {
  final AuthLocal _authLocal = AuthLocal();
  late final AuthCubit _authCubit;
  String versionNumber = "-.-.-";

  @override
  void initState() {
    super.initState();
    _getAppVersion();

    _authCubit = getIt<AuthCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionNumber = packageInfo.version;
    });
  }

  Future<void> _checkAuth() async {
    if (!mounted) return;

    try {
      final token = _authLocal.getToken();

      if (token == null) {
        await Future.delayed(const Duration(seconds: 50));
        if (!mounted) return;

        if (_authLocal.getLoginType() != null && _authLocal.getLoginType() == "guest") return _navigateToGuestDashboard();
        _navigateToLogin();
        return;
      }

      await _authCubit.checkToken(token);

      if (!mounted) return;

      _navigateToUserDashboard(_authCubit.state.user);
    } on RepositoryException catch (e) {
      if (mounted) {
        AlertNotification.warning(context, e.message);
        _navigateToLogin();
      }
    } catch (e) {
      if (mounted) {
        AlertNotification.warning(context, "Terjadi kesalahan. Silakan coba lagi.");
        _navigateToLogin();
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        duration: const Duration(milliseconds: 500),
        child: const LoginScreen(),
      ),
    );
  }

  void _navigateToUserDashboard(AuthEntity userInfo) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        duration: const Duration(milliseconds: 500),
        child: UserDashboardScreen(user: userInfo),
      ),
    );
  }

  void _navigateToGuestDashboard() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        duration: const Duration(milliseconds: 500),
        child: GuestDashboardScreen(),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: ColorConstant.primary,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetConstant.appLogo, fit: BoxFit.cover, width: 150),
                  const SizedBox(height: 20),
                  LoadingAnimationWidget.waveDots(color: ColorConstant.secondary, size: 30),
                  const Text("Loading...", style: TextStyle(color: ColorConstant.secondary)),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "GEBOK",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ColorConstant.secondary),
                  ),
                  Text("Google e-Book", style: TextStyle(fontSize: 16, color: ColorConstant.secondary)),
                  const SizedBox(height: 10),
                  Text("version $versionNumber", style: TextStyle(fontSize: 16, color: ColorConstant.secondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoadingScreen();
  }
}
