import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:work2/constants/colors.dart';
import 'account_client.dart';
import 'map_client.dart';
import 'orders_clint.dart';

class ClintNavBar extends StatefulWidget {
  const ClintNavBar({super.key});

  @override
  _ClintNavBarState createState() => _ClintNavBarState();
}

class _ClintNavBarState extends State<ClintNavBar> {
  int _currentIndex = 1;

  Widget _createScreen(int index) {
    // Adjust the index based on RTL or LTR
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    if (isRTL) {
      index = 2 - index; // Reverse the index for RTL
    }

    switch (index) {
      case 0:
        return Directionality(
            textDirection: TextDirection.ltr,
          child: OrdersClient());
      case 1:
        return ClientMap();
      case 2:
        return Directionality(
            textDirection: TextDirection.ltr,
          child: AccountClient());
      default:
        return Directionality(
            textDirection: TextDirection.ltr,
          child: OrdersClient());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    List<BottomNavigationBarItem> tabBarItems = [
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
    ];

    if (isRTL) {
      tabBarItems = tabBarItems.reversed.toList(); // Reverse the order of the items for RTL
    }

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 70,
        items: tabBarItems,
        onTap: (index) {
          setState(() {
            _currentIndex = isRTL ? 2 - index : index;
          });
        },
        currentIndex: isRTL ? 2 - _currentIndex : _currentIndex,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _createScreen(index);
          },
        );
      },
    );
  }
}
