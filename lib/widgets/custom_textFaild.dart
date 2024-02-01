import 'package:flutter/material.dart';
import 'package:work2/constants/colors.dart';

import '../generated/l10n.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final double fieldHeight;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int? maxLines;
  final String? Function(String?)? onChange;

  CustomTextField({
    Key? key,
    required this.labelText,
    this.fieldHeight = 90.0,
    this.controller,
    this.keyboardType = TextInputType.text, 
    this.validator,
    this.suffixIcon,
    this.maxLines,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Container(
        height: fieldHeight,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType, // Use keyboardType
          maxLines: maxLines, // Use it here

          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: suffixIcon,
            ),
          ),
          onChanged: onChange,
          validator: validator, 
        ),
      ),
    );
  }
}

class CustomMultiLineFormField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  CustomMultiLineFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.multiline,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 104.0, // Minimum height
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 3),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: 4, // Maximum number of lines
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
            ),
            alignLabelWithHint: true,
            hintStyle: TextStyle(color: greyColor),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),

          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return '${S.of(context).Name3} $labelText';
                }
                return null;
              },
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final String? fontFamily;

  CustomText({
    Key? key,
    required this.text,
    this.fontSize = 14.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
