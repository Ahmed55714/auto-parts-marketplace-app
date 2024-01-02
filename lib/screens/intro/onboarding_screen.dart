import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: deepPurple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 63.49),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/Group1.svg",
                      width: 127,
                      height: 25.375,
                    ),
                    const SizedBox(height: 18.13),
                    const Text(
                      'Welcome to Your Journey',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                          fontFamily: 'BakbakOne'),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 305,
                        height: 50,
                        child: const Text(
                          'Explore a world of possibilities and unlock your potential with us!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'BahijTheSansArabic'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 37.84),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      "assets/images/Vector.svg",
                      width: 150,
                      height: 180,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topRight,
                      children: [
                        ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: 0.67,
                            child: Container(
                              height: 430,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(1068.0),
                                  topRight: Radius.circular(1068.0),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 60),
                                  child: CustomButton(
                                    text: 'Get Started',
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/signin');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.12,
                          right: MediaQuery.of(context).size.width * -0.15,
                          child: Container(
                            child: Image.asset(
                              'assets/images/Car.png',
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
