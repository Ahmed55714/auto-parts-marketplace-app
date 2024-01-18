// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:work2/constants/colors.dart';

import '../../generated/l10n.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';

class OrderRepo extends StatefulWidget {
  int orderId;
   final VoidCallback onSubmissionSuccess;

  OrderRepo({
    Key? key,
    required this.orderId,
    required this.onSubmissionSuccess,
  }) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<OrderRepo> {
  final _formKey = GlobalKey<FormState>();

  final reportController = TextEditingController();
     


  Future<void> submitReturnReason(int orderId, String returnReason) async {
    final Uri apiEndpoint = Uri.parse(
        'https://slfsparepart.com/api/client/orders/${orderId}/return'); // Replace with your API endpoint
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.post(apiEndpoint, headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer $authToken', // Assuming you're using token-based authentication
      }, body: {
        'return_reason': returnReason,
      });

      if (response.statusCode == 200) {
     widget.onSubmissionSuccess();
      } else {
        // Handle error
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButtonDeep(),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).Orders,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 310,
                    child: Text(
                      S.of(context).AreCancel45,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: greyColor,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomMultiLineFormFieldWidget(
                    label: S.of(context).AreCancel46,
                    controller: reportController,
                    type: TextInputType.multiline,
                    text: S.of(context).AreCancel47,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: S.of(context).Com5,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String returnReason = reportController.text;
                        submitReturnReason(widget.orderId, returnReason)
                            .then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrueReturnScreen(),
                            ),
                          );
                        }).catchError((error) {
                          // Handle or show error
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final String text;

  const CustomTextFieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    required this.type,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          labelText: text,
          controller: controller,
          keyboardType: type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${S.of(context).Name3} $label';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class CustomMultiLineFormFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final String text;

  const CustomMultiLineFormFieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    required this.type,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        CustomMultiLineFormField(
          labelText: text,
          controller: controller,
          keyboardType: type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${S.of(context).Name3} $label';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
