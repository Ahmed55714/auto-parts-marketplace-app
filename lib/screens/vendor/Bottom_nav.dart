import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:work2/constants/colors.dart';
import 'Registration_form.dart';
import 'map_vendor.dart';
import 'my_account.dart';
import 'orders.dart';


class VendorMap extends StatefulWidget {
  const VendorMap({super.key});

  @override
  _VendorMapState createState() => _VendorMapState();
}

class _VendorMapState extends State<VendorMap> {
  // Set the initial index to 1 to start from MyMap screen
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const MyOrders(),
    MyMap(),
    MyAccount(),
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


class BackButtonDeep extends StatelessWidget {
  const BackButtonDeep({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios,
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
    Key? key, required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                Icons.arrow_back_ios,
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
