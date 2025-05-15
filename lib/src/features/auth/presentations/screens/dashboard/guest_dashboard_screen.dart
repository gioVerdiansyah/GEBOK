import 'package:animations/animations.dart';
import 'package:book_shelf/src/core/system/auth_local.dart';
import 'package:book_shelf/src/features/books/presentations/screens/home/home_screen.dart';
import 'package:book_shelf/src/features/books/presentations/screens/home/info_app_screen.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../shared/constants/asset_constant.dart';
import '../../../../../shared/widgets/others/dynamic_app_bar.dart';
import '../../../../books/presentations/widgets/screen/search_screen.dart';
import '../../blocs/bloc/auth_cubit.dart';
import '../../blocs/state/auth_state.dart';
import '../login_screen.dart';

class GuestDashboardScreen extends StatefulWidget {
  const GuestDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardView();
}

class _DashboardView extends State<GuestDashboardScreen> {
  final ScrollController _scrollControllerHome = ScrollController();

  @override
  void dispose() {
    _scrollControllerHome.dispose();
    super.dispose();
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
          BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder:
                  (context, state) => PopupMenuButton<String>(
                    offset: Offset(0, 60),
                    color: ColorConstant.secondary,
                    tooltip: "Menu",
                    onSelected: (val) async {
                      if (val == "logout") {
                        await context.read<AuthCubit>().logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                        );
                      } else if (val == "info") {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 500),
                            child: InfoAppScreen(),
                          ),
                        );
                      }
                    },
                    itemBuilder:
                        (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(children: [Icon(Icons.exit_to_app_outlined), SizedBox(width: 4), Text('Logout')]),
                          ),
                          const PopupMenuItem<String>(
                            value: 'info',
                            child: Row(children: [Icon(Icons.info_outline), SizedBox(width: 4), Text('Info App')]),
                          ),
                        ],
                  ),
            ),
          ),
        ],
      ),
      body: HomeScreen(scrollController: _scrollControllerHome),
    );
  }
}
