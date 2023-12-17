import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:work2/constants/colors.dart';

class CustomSelection extends StatelessWidget {
  final int index;
  final bool isSelected;
  final String title;
  final String description;
  final VoidCallback onTap;

  CustomSelection({
    required this.index,
    required this.isSelected,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 102,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? deepPurple : greyColor,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Padding(
                padding: const EdgeInsets.all(18.0),
                child: AnimatedContainer(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(

                    color: isSelected ? deepPurple : greyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      bottomLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomRight: Radius.circular(10),
                    )
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastOutSlowIn,
                  child: Visibility(
                    visible: isSelected,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AnimatedContainer(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Container(
                    margin: const EdgeInsets.only( top: 19),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 23),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? deepPurple : greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30, top: 9),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? deepPurple : greyColor,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80.0),
                child: AnimatedContainer(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isSelected ? deepPurple : greyColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastOutSlowIn,
                  child: Visibility(
                    visible: isSelected,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AnimatedContainer(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomSelection1 extends StatelessWidget {
  final int index;
  final bool isSelected;
  final String title;
  final String description;
  final VoidCallback onTap;

  CustomSelection1({
    required this.index,
    required this.isSelected,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 102,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? deepPurple : greyColor,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                
               
                children: [
                  
                  Container(
                    margin: const EdgeInsets.only( top: 0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 0),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? deepPurple : greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(left: 30, top: 9),
                  //   child: Text(
                  //     description,
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w500,
                  //       color: isSelected ? deepPurple : greyColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80.0),
                child: AnimatedContainer(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isSelected ? deepPurple : greyColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastOutSlowIn,
                  child: Visibility(
                    visible: isSelected,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AnimatedContainer(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Ensure you have this import

class CustomSelectionStepProgress extends StatefulWidget {
  final int index;
  final bool isSelected;
  final String title;
  final String description;
  final String svgAsset; // Path to your SVG file in the assets
  final VoidCallback onTap;

  CustomSelectionStepProgress({
    required this.index,
    required this.isSelected,
    required this.title,
    required this.description,
    required this.svgAsset,
    required this.onTap,
  });

  @override
  State<CustomSelectionStepProgress> createState() =>
      _CustomSelectionStepProgressState();
}

class _CustomSelectionStepProgressState
    extends State<CustomSelectionStepProgress> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: widget.isSelected ? greyColor : greyColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected ? deepPurple : greyColor,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SvgPicture.asset(
                  widget.svgAsset,
                  width: 40, // Adjust the size as needed
                  height: 40,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: widget.isSelected ? deepPurple : deepPurple,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: widget.isSelected ? deepPurple : deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
