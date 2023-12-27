import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work2/widgets/custom_button.dart';

import '../../constants/colors.dart';
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
            const Center(
              child: Text(
                'Sign Up',
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
                Container(
                  width: 250,
                  child: const Text(
                    'Welecome to SLF please choose your account type to continue. ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                      color: greyColor,
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
                text: 'Sign up as Client',
                onPressed: () {
                  handleSignUp('client');
                }),
            const SizedBox(height: 12),
            CustomButton2(
                text: 'Sign up as service vendor',
                onPressed: () {
                  handleSignUp('vendor');
                }),
            const SizedBox(height: 12),
            CustomButton2(
                text: 'Special Client',
                onPressed: () {
                  handleSignUp('special_client');
                })
          ],
        ),
      ),
    );
  }
}
