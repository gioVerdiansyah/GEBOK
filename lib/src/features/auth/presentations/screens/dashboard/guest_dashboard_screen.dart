import 'package:animations/animations.dart';
import 'package:book_shelf/src/core/system/auth_local.dart';
import 'package:book_shelf/src/features/books/presentations/screens/home/home_screen.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../../shared/constants/asset_constant.dart';
import '../../../../../shared/widgets/others/dynamic_app_bar.dart';
import '../../../../books/presentations/widgets/screen/search_screen.dart';
import '../login_screen.dart';

class GuestDashboardScreen extends StatefulWidget{
  const GuestDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardView();
}

class _DashboardView extends State<GuestDashboardScreen> {
  final ScrollController _scrollControllerHome = ScrollController();
  final AuthLocal _authLocal = AuthLocal();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerHome.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await _authLocal.clearAuthData();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DynamicAppBar(
        backgroundColor: ColorConstant.secondary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetConstant.appLogo, width: 30),
            const SizedBox(width: 8),
            Text("GEBOK", style: TextStyle(color: ColorConstant.primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        trailingWidgets: [
          OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            transitionDuration: Duration(milliseconds: 600),
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            closedBuilder: (context, openContainer) {
              return IconButton(
                icon: const Icon(Icons.search, color: ColorConstant.gray),
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: SearchScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              );
            },
            openBuilder: (context, _) => Container(),
          ),
          PopupMenuButton<String>(
            offset: Offset(0, 60),
            color: ColorConstant.secondary,
            tooltip: "Menu",
            onSelected: (val) async {
              if(val == "logout"){
                _handleLogout();
              }else if(val == "info"){

              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app_outlined),
                    SizedBox(width: 4),
                    Text('Logout'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'info',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 4),
                    Text('Info App'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: HomeScreen(scrollController: _scrollControllerHome,)
    );
  }
}