import 'package:flutter/material.dart';
import 'package:work2/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final double fieldHeight;
  final TextInputType keyboardType; 
  final String? Function(String?)? validator; 
  final Widget? suffixIcon;
  

  CustomTextField({
    Key? key,
    required this.labelText,
    this.fieldHeight = 58.0,
    this.controller,
    this.keyboardType = TextInputType.text, // Default keyboardType is text
    this.validator, 
     this.suffixIcon, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom:18),
      child: Container(
        height: fieldHeight,
        child: TextFormField(
          
          controller: controller,
          keyboardType: keyboardType, // Use keyboardType
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14,),
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
          validator: validator, // Use validator
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
        padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: 4, // Maximum number of lines
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontFamily: 'Roboto', fontSize: 14,),
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
          
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
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


