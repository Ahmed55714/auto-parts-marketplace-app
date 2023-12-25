import 'package:flutter/material.dart';

import 'package:work2/constants/colors.dart';

import '../../Bottom_nav.dart';
import '../widgets/contacts_list.dart';

class MobileLayoutScreen extends StatelessWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButtonDeep(),
                    ],
                  ),
                ),
                Text(
                  'Chat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
                const SizedBox(height: 15),
                const ContactsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
