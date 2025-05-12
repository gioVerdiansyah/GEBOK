import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AlertNotification {
  static error(BuildContext context, String title, {String? messages, int? duration}) {
    return _showAlert(
      context: context,
      title: title,
      messages: messages,
      duration: duration,
      type: ToastificationType.error,
      icon: Icons.error,
    );
  }

  static success(BuildContext context, String title, {String? messages, int? duration}) {
    return _showAlert(
      context: context,
      title: title,
      messages: messages,
      duration: duration,
      type: ToastificationType.success,
      icon: Icons.check_circle,
    );
  }

  static warning(BuildContext context, String title, {String? messages, int? duration}) {
    return _showAlert(
      context: context,
      title: title,
      messages: messages,
      duration: duration,
      type: ToastificationType.warning,
      icon: Icons.warning,
    );
  }

  static clearAll(){
    return toastification.dismissAll();
  }

  static _showAlert({
    required BuildContext context,
    required String title,
    required ToastificationType type,
    required IconData icon,
    String? messages,
    int? duration,
  }) {
    return toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: (duration != null) ? Duration(milliseconds: duration) : const Duration(milliseconds: 15000),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.black),),
      description: (messages != null) ? RichText(text: TextSpan(text: messages, style: const TextStyle(color: ColorConstant.black))
      ) : null,
      icon: Icon(icon),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      borderRadius: BorderRadius.circular(8),
      animationBuilder: (
          BuildContext context,
          Animation<double> animation,
          Alignment alignment,
          Widget child,
          ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          )),
          child: child,
        );
      },
    );
  }
}
