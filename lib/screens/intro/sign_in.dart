import 'dart:math';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/widgets/custom_button.dart';

import '../../generated/l10n.dart';
import '../../getx/auth.dart';
import 'onboarding_screen.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isProcessing = false;

  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  String? phoneNumberError;
  String? verificationId;
  Key countryPickerKey = UniqueKey();
  final AuthController authController = Get.put(AuthController());
  final LocaleController localeController = Get.put(LocaleController());

  void validatePhoneNumber(String value) async {
    setState(() {
      isProcessing = false;
    });

    String? value = phoneController.text;
    if (value.isEmpty) {
      setState(() {
        phoneNumberError = S.of(context).valid1;
      });
    } else if (value.length < 9) {
      setState(() {
        phoneNumberError = S.of(context).valid2;
      });
    } else if (countryCode == null) {
      setState(() {
        phoneNumberError = S.of(context).valid3;
      });
    } else {
      setState(() {
        phoneNumberError = null;
      });
      final fullNumber = '${countryCode?.dialCode ?? ''}$value';
      authController.verifyPhoneNumber(fullNumber);
      setState(() {
        isProcessing = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    localeController.addListener(_updateCountryPickerKey);
  }

  void _updateCountryPickerKey() {
    setState(() {
      phoneNumberError = null;
      countryPickerKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    EdgeInsets paddingForTextFields = isRTL
        ? const EdgeInsets.only(right: 8)
        : const EdgeInsets.only(left: 8);

    EdgeInsets paddingForErrorMessages = isRTL
        ? const EdgeInsets.only(top: 8.0, right: 26.0)
        : const EdgeInsets.only(top: 8.0, left: 26.0);
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
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).SignIn2,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                      color: deepPurple,
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
                          padding: paddingForTextFields,
                          child: GestureDetector(
                            key: countryPickerKey,
                            onTap: () async {
                              final code = await FlCountryCodePicker(
                                localize: true, // Ensure this is set
                              ).showPicker(context: context);

                              setState(() {
                                countryCode = code;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    final code = await FlCountryCodePicker(
                                      localize: true,
                                      title: Padding(
                                        padding: paddingForTextFields,
                                        child: Text(
                                          S.of(context).Picker,
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      searchBarDecoration: InputDecoration(
                                        hintText: S.of(context).Search,
                                        contentPadding: EdgeInsets.all(12.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Added this line
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: BorderSide(
                                            color: Colors
                                                .grey, // You can change this color as needed
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // And this line
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: BorderSide(
                                            color: Colors
                                                .grey, // And the color here
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ).showPicker(context: context);

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
                            padding: paddingForTextFields,
                            child: Row(
                              children: [
                                countryCode != null
                                    ? CountryCodeFlagWidget(
                                        width: 35,
                                        alignment: Alignment.center,
                                        countryCode: countryCode!)
                                    : Text(
                                        S.of(context).KSA,
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
                          padding: paddingForTextFields,
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
                      padding: paddingForErrorMessages,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.9, // Adjust the width as needed
                        child: Text(
                          S.of(context).SignIn3,
                          textAlign: TextAlign.center, // Center align the text
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
                  const SizedBox(height: 34),
                  CustomButton(
                      text: isProcessing
                          ? S
                              .of(context)
                              .button2 // "انتظر قليلا" when processing
                          : (phoneNumberError == null
                              ? S.of(context).button
                              : S
                                  .of(context)
                                  .button2), // "التالي" or error text
                      onPressed: () {
                        final value = phoneController.text;
                        if (formKey.currentState!.validate() &&
                            phoneNumberError == null) {
                          setState(() {
                            validatePhoneNumber(value);
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
  @override
  void dispose() {
    localeController.removeListener(_updateCountryPickerKey);
    super.dispose();
  }
}
