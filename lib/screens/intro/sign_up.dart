import 'package:flutter/material.dart';
import 'package:work2/widgets/custom_button.dart';

import '../../constants/colors.dart';


class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
            const Text(
              'Lorem ipsum dolor sit amet, consectetur ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
             
                color: greyColor,
              ),
            ),
            const SizedBox(height: 53),
            Image.asset(
              'assets/images/SLFimage.png',
              height: 182,
              width: 194,
            ),
            const SizedBox(height: 59),
            CustomButton2(text: 'Sign up as Client', onPressed: () {
              Navigator.pushNamed(context, '/clientmap');
            }),
            const SizedBox(height: 12),
            CustomButton2(
                text: 'Sign up as service provider', onPressed: () {
              Navigator.pushNamed(context, '/vendormap');
                }),
            const SizedBox(height: 12),
            CustomButton2(text: 'Special Client', onPressed: () {
              Navigator.pushNamed(context, '/clientmap');
            })
          ],
        ),
      ),
    );
  }
}
