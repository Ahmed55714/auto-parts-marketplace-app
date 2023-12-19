import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/widgets/custom_button.dart';

import 'verification.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  String? phoneNumberError;
  String? verificationId;

  void validatePhoneNumber(String value) async {
    String? value = phoneController.text;
    if (value.isEmpty) {
      setState(() {
        phoneNumberError = 'Please enter your phone number';
      });
    } else if (value.length < 9) {
      setState(() {
        phoneNumberError = 'Please enter a valid phone number';
      });
    } else if (countryCode == null) {
      setState(() {
        phoneNumberError = 'Please select your country code';
      });
    } else {
      setState(() {
        phoneNumberError = null;
      });
      final fullNumber = '${countryCode?.dialCode ?? ''}$value';
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle error
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save the verification ID and navigate to the verification screen
          verificationId = verificationId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationScreen(
                verificationId: verificationId,
                value: fullNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timeout
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,

                      color:
                          deepPurple, // Ensure deepPurple is defined in your colors constants
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your phone number',
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
                    height: 130.0,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Country / Region',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
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
                                      right: 10, left: 10),
                                  child: SvgPicture.asset(
                                    "assets/images/Vector2.svg",
                                    width: 10,
                                    height: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 8, bottom: 8),
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
                              Text(
                                countryCode?.dialCode ?? '+966',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Line
                        Container(
                          height: 0.741, // Height of the line
                          color: const Color(0xFFB0B0B0), // Color of the line
                        ),

                        // Second TextField (below the line)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            controller: phoneController,
                            decoration: const InputDecoration(
                              border: InputBorder.none, // Hides the border
                              hintText: 'Phone Number',

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
                  const Center(
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur\n adipiscing elit, sed do eiusmod tempor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        color: greyColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  CustomButton(
                      text: 'Next',
                      onPressed: () {
                        final value = phoneController.text;
                        if (formKey.currentState!.validate() &&
                            phoneNumberError == null) {
                          validatePhoneNumber(value);

                          //Navigator.pushNamed(context, '/Verification');
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
