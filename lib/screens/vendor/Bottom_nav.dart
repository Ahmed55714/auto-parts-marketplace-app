import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:work2/constants/colors.dart';
import '../client/account_client.dart';
import 'map_vendor.dart';
import 'orders.dart';

class VendorMap extends StatefulWidget {
  const VendorMap({super.key});

  @override
  _VendorMapState createState() => _VendorMapState();
}

class _VendorMapState extends State<VendorMap> {
  int _currentIndex = 1;

  // Function to create the widget based on the index
  Widget _createScreen(int index) {
    // Adjust the index based on RTL or LTR
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    if (isRTL) {
      index = 2 - index; // Reverse the index for RTL
    }

    switch (index) {
      case 0:
        return Directionality(
            textDirection: TextDirection.ltr, child: MyOrders());

      case 1:
        return MyMap();
      case 2:
        return Directionality(
            textDirection: TextDirection.ltr, child: AccountClient());

      default:
        return Directionality(
            textDirection: TextDirection.ltr, child: MyOrders());
      // Default case
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
      tabBarItems = tabBarItems.reversed
          .toList(); // Reverse the order of the items for RTL
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

class BackButtonDeep extends StatelessWidget {
  const BackButtonDeep({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: deepPurple,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonDeep1 extends StatelessWidget {
  final Function onTap;
  const BackButtonDeep1({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              onTap;
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: deepPurple,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


