import 'package:book_shelf/src/core/di/injection.dart';
import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';
import 'package:book_shelf/src/features/auth/presentations/blocs/bloc/auth_cubit.dart';
import 'package:book_shelf/src/features/auth/presentations/blocs/state/auth_state.dart';
import 'package:book_shelf/src/features/auth/presentations/screens/dashboard_screen.dart';
import 'package:book_shelf/src/shared/constants/asset_constant.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:book_shelf/src/shared/widgets/notification/alert_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginView();
}

class _LoginView extends State<LoginScreen> {
  DateTime? _lastBackPressed;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressed == null || now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tekan sekali lagi untuk keluar'), duration: Duration(seconds: 2)));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ColorConstant.primary,
        body: BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.api.isSuccess) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => DashboardScreen(user: state.user)),
                  (route) => false,
                );
              } else if (state.api.error != null) {
                AlertNotification.warning(context, state.api.error!.message);
              }
            },
            builder: (context, state) {
              return _buildContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AuthState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorConstant.secondary,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FadeInImage(
                  image: AssetImage(AssetConstant.appLogo),
                  fit: BoxFit.cover,
                  width: 100,
                  placeholder: ResizeImage(AssetImage(AssetConstant.loading), width: 40),
                ),
                Text("GEBOK", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ColorConstant.primary)),
                Text("Google e-Book", style: TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 30),

                // Login with Google Button
                _buildLoginButton(
                  icon: Image.asset(AssetConstant.googleLogo, width: 24, height: 24),
                  label: "Masuk dengan Google",
                  onPressed: () {
                    context.read<AuthCubit>().loginWithGoogle();
                  },
                ),

                const SizedBox(height: 15),

                _buildLoginButton(
                  icon: const Icon(Icons.person_outline, size: 24, color: Colors.black),
                  label: "Masuk dengan guest",
                  onPressed: () {
                    // Handle guest login
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton({required Widget icon, required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
