import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'package:http/http.dart' as http;


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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(text: 'Name'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    labelText: 'Name',
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  buildDateFieldDate(
                    'complaint Date',
                    dateController,
                  ),
                  CustomMultiLineFormFieldWidget(
                    label: 'Report',
                    controller: reportController,
                    type: TextInputType.multiline,
                    text: 'Placeholder',
                  ),
                  SubmitButtonWidget(
                    formKey: _formKey,
                    nameController: nameController,
                    dateController: dateController,
                    reportController: reportController,
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

  Widget buildDateFieldDate(
    String label,
    TextEditingController controller, {
    String? initialText,
  }) {
    // Function to handle date picking
    Future<void> _selectDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialText != null
            ? DateFormat('yyyy-MM-dd').parse(initialText)
            : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != initialText) {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            // Prevents keyboard from showing
            child: CustomTextField(
              labelText:
                  controller.text.isEmpty ? 'YYYY-MM-DD' : controller.text,
              controller: controller,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
            ),
          ),
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
  final TextEditingController nameController;
  final TextEditingController dateController;
  final TextEditingController reportController;

  const SubmitButtonWidget({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.dateController,
    required this.reportController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomButton(
          text: 'Submit',
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              // If the form is valid, perform the HTTP request
              await submitComplain(
                  nameController.text,
                  dateController.text, reportController.text, context);
            }
          },
        ),
      ],
    );
  }
}

Future<void> submitComplain(String name,
    String date, String report, BuildContext context) async {
  final Uri apiEndpoint =
      Uri.parse('https://slfsparepart.com/api/vendor/complain');
  final prefs = await SharedPreferences.getInstance();
  final String? authToken = prefs.getString('auth_token');

  try {
    final response = await http.post(
      apiEndpoint,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: {
        'client_name': name,
        'date': date,
        'report': report,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complain submitted successfully')),
      );
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrueComplinPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to submit complaint${response.statusCode}}')),
      );
   
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred while submitting complaint: $e')),
    );
  }
}
