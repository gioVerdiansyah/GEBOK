import 'package:animations/animations.dart';
import 'package:book_shelf/src/features/auth/domain/entities/auth_entity.dart';
import 'package:book_shelf/src/features/books/presentations/screens/home/home_screen.dart';
import 'package:book_shelf/src/features/books/presentations/screens/library/library_screen.dart';
import 'package:book_shelf/src/shared/constants/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../../shared/constants/asset_constant.dart';
import '../../../../../shared/widgets/others/dynamic_app_bar.dart';
import '../../../../books/presentations/screens/favorite/favorite_screen.dart';
import '../../../../books/presentations/widgets/screen/search_screen.dart';

class UserDashboardScreen extends StatefulWidget{
  final AuthEntity user;

  const UserDashboardScreen({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _DashboardView();
}

class _DashboardView extends State<UserDashboardScreen> {
  late PersistentTabController _controller;

  final ScrollController _scrollControllerHome = ScrollController();
  final ScrollController _scrollControllerLibrary = ScrollController();
  final ScrollController _scrollControllerShop = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(scrollController: _scrollControllerHome,),
      LibraryScreen(scrollController: _scrollControllerLibrary,),
      FavoriteScreen(scrollController: _scrollControllerShop,)
    ];
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
            onSelected: (value) {
              print('Selected: $value');
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          )
        ],
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardAppears: true,
        // popBehaviorOnSelectedNavBarItemPress: PopActionScreensType.all,
        padding: const EdgeInsets.only(top: 8),
        backgroundColor: ColorConstant.secondary,
        isVisible: true,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: kBottomNavigationBarHeight,
        navBarStyle: NavBarStyle.style3,
      )
    );
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        scrollController: _scrollControllerHome,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.book),
        title: ("Library"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        scrollController: _scrollControllerLibrary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: ("Shop"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        scrollController: _scrollControllerShop,
      ),
    ];
  }

}