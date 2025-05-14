import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/color_constant.dart';

class DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Alignment? titleAlignment;
  final Widget? leadingWidget;
  final List<Widget>? trailingWidgets;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final TextStyle? titleStyle;
  final bool useWhiteStatusBar;
  final Color statusBarColor;

  const DynamicAppBar({
    Key? key,
    this.title,
    this.titleAlignment = Alignment.center,
    this.leadingWidget,
    this.trailingWidgets,
    this.onBackPressed,
    this.showBackButton = false,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 4.0,
    this.titleStyle,
    this.useWhiteStatusBar = true,
    this.statusBarColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;

    SystemChrome.setSystemUIOverlayStyle(
      useWhiteStatusBar
          ? const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      )
          : const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLeading(context) != null
                ? SizedBox(child: _buildLeading(context))
                : const SizedBox(width: 8),
            Expanded(
              child: Container(
                alignment: titleAlignment,
                child: title,
              ),
            ),
            trailingWidgets != null && trailingWidgets!.isNotEmpty
                ? Row(mainAxisSize: MainAxisSize.min, children: trailingWidgets!)
                : const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leadingWidget != null) {
      return leadingWidget;
    } else if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorConstant.black),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }
    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}