import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocaleController localeController = Get.put(LocaleController());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    // Adjust alignments and paddings based on the locale
    EdgeInsetsGeometry padding = isRTL
        ? const EdgeInsets.only(left: 63.49)
        : const EdgeInsets.only(right: 63.49);
    return Scaffold(
      backgroundColor: deepPurple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 63.49),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Get.locale?.languageCode == 'en'
                      ? Image.asset(
                          'assets/images/unitedstates.png',
                          width: 35,
                          height: 35,
                        )
                      : Image.asset(
                          'assets/images/saudiarabia.png',
                          width: 35,
                          height: 35,
                        ),
                  onPressed: () {
                    if (Get.locale?.languageCode == 'en') {
                      localeController.changeLanguage('ar');
                    } else {
                      localeController.changeLanguage('en');
                    }
                  },
                ),
              ),
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
                    Text(
                      S.of(context).titleBording2,
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
                        child: Text(
                          S.of(context).titleBording,
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
                crossAxisAlignment:
                    isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                                    text: S.of(context).titleBording3,
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

class LocaleController extends GetxController {
  void changeLanguage(String languageCode) {
    Locale newLocale = Locale(languageCode);
    Get.updateLocale(newLocale);
  }
}
