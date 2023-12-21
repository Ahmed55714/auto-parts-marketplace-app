import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'account_client.dart';
import 'map_client.dart';
import 'orders_clint.dart';

class ClintNavBar extends StatefulWidget {
  const ClintNavBar({super.key});

  @override
  _ClintNavBarState createState() => _ClintNavBarState();
}

class _ClintNavBarState extends State<ClintNavBar> {
  // Set the initial index to 1 to start from ClientMap screen
  int _currentIndex = 1;

  final List<Widget> _screens = [
    OrdersClient(),
    ClientMap(),
    AccountClient(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 70,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentIndex == 0
                  ? 'assets/images/note-textt.svg'
                  : 'assets/images/note-text.svg',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentIndex == 1
                  ? 'assets/images/homee.svg'
                  : 'assets/images/home.svg',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentIndex == 2
                  ? 'assets/images/userr.svg'
                  : 'assets/images/user.svg',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _screens[index];
          },
        );
      },
    );
  }
}