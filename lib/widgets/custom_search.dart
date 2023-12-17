import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/colors.dart';


class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Placeholder',
          hintStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            fontFamily: 'BahijTheSansArabic',
          ),
          prefixIcon:  Padding(
            padding: EdgeInsets.all(16.0),
            child: SvgPicture.asset(  'assets/images/filled.svg' , height: 24, width: 24),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}