import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../vendor/Bottom_nav.dart';

class TermsAndConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButtonDeep(),
                  ],
                ),
              ),
              const Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              for (int i = 1; i <= 3; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$i- Lorem ipsum dolor sit amet,',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          ' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
                          style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
