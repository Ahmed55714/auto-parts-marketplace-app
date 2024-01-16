import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work2/widgets/custom_button.dart';

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../../getx/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthController authController = Get.find<AuthController>();

  void handleSignUp(String userType) async {
    // Call the postType method from AuthController
    await authController.postType(userType);

    // After posting the type, navigate to the next screen based on userType
    if (userType == 'client') {
      Navigator.pushNamed(context, '/clientmapNav');
      authController.saveUserType('client');
    } else if (userType == 'vendor') {
      Navigator.pushNamed(context, '/vendormapNav');
      authController.saveUserType('vendor');
    } else if (userType == 'special_client') {
      // Replace '/specialclientmap' with the actual route you wish to navigate to
      Navigator.pushNamed(context, '/clientmapNav');
      authController.saveUserType('client');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
             Center(
              child: Text(
                S.of(context).SignUP,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 340,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.9, // Adjust the width as needed
                          child: Text(
                           S.of(context).SignUp2,
                            textAlign:
                                TextAlign.center, // Center align the text
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                              color: greyColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 53),
            Image.asset(
              'assets/images/SLFimage.png',
              height: 182,
              width: 194,
            ),
            const SizedBox(height: 59),
            CustomButton2(
                text: S.of(context).SignUP3,
                onPressed: () {
                  handleSignUp('client');
                }),
            const SizedBox(height: 12),
            CustomButton2(
                text: S.of(context).SignUP4,
                onPressed: () {
                  handleSignUp('vendor');
                }),
            const SizedBox(height: 12),
            CustomButton2(
                text: S.of(context).SignUP5,
                onPressed: () {
                  handleSignUp('special_client');
                })
          ],
        ),
      ),
    );
  }
}
