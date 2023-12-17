import 'package:flutter/material.dart';
import 'package:work2/constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';

class ReportClient extends StatefulWidget {
  const ReportClient({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<ReportClient> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final reportController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButtonDeep(),
                      ],
                    ),
                  ),
                  const Text(
                    'Complain',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFieldWidget(
                    label: 'Client Name',
                    controller: nameController,
                    type: TextInputType.text,
                    text: 'Placeholder',
                  ),
                  CustomTextFieldWidget(
                    label: 'Date',
                    controller: dateController,
                    type: TextInputType.text,
                    text: 'dd/mm/yy',
                  ),
                  CustomMultiLineFormFieldWidget(
                    label: 'Report',
                    controller: reportController,
                    type: TextInputType.multiline,
                    text: 'Placeholder',
                  ),
                  SubmitButtonWidget(formKey: _formKey),
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
              return 'Please enter $label';
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
              return 'Please enter $label';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class SubmitButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SubmitButtonWidget({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomButton(
          text: 'Submit',
          onPressed: () {
            if (formKey.currentState!.validate()) {
              // Handle form submission
            }

             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>TrueScreen(),
                // const CarForm(),
              ),
            );
            // showDialog(
            //   context: context,
            //   barrierDismissible: false,
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: Center(
            //         child: Icon(
            //           Icons.check_circle,
            //           color: Colors.green,
            //           size: 60,
            //         ),
            //       ),
            //       content: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           CustomText(
            //             text: 'Submited',
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ],
            //       ),
            //       actions: <Widget>[
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const SizedBox(height: 7),
            //             CustomButton(
            //               text: 'Home page',
            //               onPressed: () {},
            //             )
            //           ],
            //         ),
            //       ],
            //     );
            //   },
            // );
          },
        ),
      ],
    );
  }
}
