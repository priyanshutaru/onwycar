import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onwycar/Screens/HomePageRelatedScreens/DuplicateHomeScreen.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../Screens/ContactRelatedScreen/contact.dart';
import '../Screens/ProfileRelatedScreens/profile.dart';
import '../Screens/TrackRelatedScreens/track.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  _BottomNavigationState();
  List<Widget> _NavScreens() {
    return [
      // DuplicateHome(),
      const Track(),
      const Contact(),
      const Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          (CupertinoIcons.train_style_one),
        ),
        title: ("Track"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.phone_solid,
        ),
        title: ("Contact"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_solid),
        title: ("Profile"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        navBarStyle: NavBarStyle.style2,
        bottomScreenMargin: 0.0,
      ),
    );
  }
}
