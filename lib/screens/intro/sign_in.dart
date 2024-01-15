import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/widgets/custom_button.dart';

import '../../generated/l10n.dart';
import '../../getx/auth.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String buttonText = 'Next';
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  String? phoneNumberError;
  String? verificationId;

  final AuthController authController = Get.put(AuthController());

  void validatePhoneNumber(String value) async {
    String? value = phoneController.text;
    if (value.isEmpty) {
      setState(() {
        phoneNumberError = 'Please enter your phone number';
        buttonText = 'Next'; // Reset button text
      });
    } else if (value.length < 9) {
      setState(() {
        phoneNumberError = 'Please enter a valid phone number';
        buttonText = 'Next'; // Reset button text
      });
    } else if (countryCode == null) {
      setState(() {
        phoneNumberError = 'Please select your country code';
        buttonText = 'Next'; // Reset button text
      });
    } else {
      setState(() {
        phoneNumberError = null;
      });
      final fullNumber = '${countryCode?.dialCode ?? ''}$value';
      authController.verifyPhoneNumber(fullNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 139),
                  Text(
                    S.of(context).SingIn,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,

                      color:
                          deepPurple, // Ensure deepPurple is defined in your colors constants
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).SignIn2,
                    style: TextStyle(
                      fontSize: 16,

                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',

                      color:
                          deepPurple, // Ensure deepPurple is defined in your colors constants
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 358.0,
                    height: 170.0,
                    padding: const EdgeInsets.fromLTRB(0.0, 11.0, 0.0, 1.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFB0B0B0), // Hex color for border
                        width: 0.741, // Border width
                      ),
                      borderRadius:
                          BorderRadius.circular(5.924), // Rounded border
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First TextField (above the line)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: GestureDetector(
                            onTap: () async {
                              final code = await countryPicker.showPicker(
                                  context: context);

                              setState(() {
                                countryCode = code;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: isRTL
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    S.of(context).SignIn4,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final code = await countryPicker.showPicker(
                                        context: context);

                                    setState(() {
                                      countryCode = code;
                                    });
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SvgPicture.asset(
                                        "assets/images/Vector2.svg",
                                        width: 15,
                                        height: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final code = await countryPicker.showPicker(
                                context: context);

                            setState(() {
                              countryCode = code;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 8, bottom: 8),
                            child: Row(
                              children: [
                                countryCode != null
                                    ? CountryCodeFlagWidget(
                                        width: 35,
                                        alignment: Alignment.center,
                                        countryCode: countryCode!)
                                    : const Text(
                                        'KSA',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    countryCode?.dialCode ?? '+966',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Line
                        Container(
                          height: 0.741, // Height of the line
                          color: const Color(0xFFB0B0B0), // Color of the line
                        ),

                        // Second TextField (below the line)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none, // Hides the border
                              hintText: S.of(context).SingIn5,

                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                color: lightGreyColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (phoneNumberError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Row(
                        children: [
                          Text(
                            phoneNumberError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 300,
                      child: Text(
                        S.of(context).SignIn3,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          color: greyColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  CustomButton(
                      text: buttonText,
                      onPressed: () {
                        final value = phoneController.text;
                        if (formKey.currentState!.validate() &&
                            phoneNumberError == null) {
                          validatePhoneNumber(value);
                          setState(() {
                            buttonText = 'Please Wait...';
                          });
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
//   @override
//   void dispose() {
//     phoneController.dispose();
//     super.dispose();
//   }
}
