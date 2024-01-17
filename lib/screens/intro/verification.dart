import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:work2/constants/colors.dart';
import '../../generated/l10n.dart';
import '../../getx/auth.dart';
import '../../widgets/custom_button.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;

  final String phoneNumber;

  VerificationScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  CountryCode? countryCode;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final _otpControllers = List.generate(6, (_) => TextEditingController());

  Future<void> resendOTP(String value) async {
    try {
      authController.verifyPhoneNumber(widget.phoneNumber);
      await sendNewOTP(value);

      // Show a message to the user indicating that the OTP has been resent
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).snack)),
      );
    } catch (e) {
      // Handle any errors that occur during OTP resending
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).snack2)),
      );
    }
  }

  Future<void> sendNewOTP(String value) async {
    final fullNumber = '${countryCode?.dialCode ?? ''}$value';
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: value,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failure
        },
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {}
  }

  Future<void> verifyOTP(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushNamed(context, '/signup');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).snack2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final number = ModalRoute.of(context)!.settings.arguments as String;
    var textDirection = Directionality.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 86),
                  Column(
                    children: [
                      Text(S.of(context).verification,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: deepPurple,
                          )),
                      SizedBox(height: 16),
                      // TitleWidget(number: Text(number))
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 290,
                                height: 75,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width:
                                          290, // You can adjust the width as needed
                                      child: Text(
                                        S.of(context).verification2,
                                        textAlign: TextAlign
                                            .center, // Center align the text
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16)
                    ],
                  ),
                  VerificationCode(otpControllers: _otpControllers),
                  const SizedBox(height: 37),
                  Center(
                    child: CustomButton(
                      text: S.of(context).Verification3,
                      onPressed: () {
                        // Navigator.pushNamed(context, '/signup');
                        String completeOTP = _otpControllers
                            .map((controller) => controller.text)
                            .join();
                        authController.verifyOtp(widget.verificationId,
                            completeOTP, widget.phoneNumber);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).Dont,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            resendOTP(widget.phoneNumber);
                          },
                          child: Text(
                            S.of(context).Resend,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String number;

  const TitleWidget({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$number",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class VerificationCode extends StatelessWidget {
  final List<TextEditingController> otpControllers;

  const VerificationCode({super.key, required this.otpControllers});

  @override
  Widget build(BuildContext context) {
    var textDirection = Directionality.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: textDirection,
        children: List.generate(
          6,
          (index) => SizedBox(
            height: 68,
            width: 45,
            child: VerificationCodeForm(controller: otpControllers[index]),
          ),
        ),
      ),
    );
  }
}

class VerificationCodeForm extends StatelessWidget {
  final TextEditingController controller;

  const VerificationCodeForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    var textDirection =
        Directionality.of(context); // Get the current text direction

    return TextFormField(
      controller: controller,
      onChanged: (value) {
        if (value.length == 1) {
          FocusScope.of(context).nextFocus();
        }
      },
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textDirection: textDirection,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: deepPurple,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: deepPurple),
        ),
      ),
    );
  }
}
