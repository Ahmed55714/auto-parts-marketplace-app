import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work2/constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import 'Bottom_nav.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool isAgreed = false;
  List<XFile> _images = [];
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers
  final nameController = TextEditingController();
  //final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final carTypeController = TextEditingController();
  final locationController = TextEditingController();
  final cartypeController = TextEditingController();


   List<String> carTypes = []; // List to store car types

  void _addCarType() {
    if (cartypeController.text.isNotEmpty) {
      setState(() {
        carTypes.add(cartypeController.text);
        cartypeController.clear();
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
   // phoneNumberController.dispose();
    emailController.dispose();
    carTypeController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() => _images.addAll(pickedImages));
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
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
                    'Registration Form',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTextField('Name', nameController, TextInputType.text,
                      'Enter your name'),
                  // buildTextField('Phone Number', phoneNumberController,
                  //     TextInputType.number, 'Enter your phone number'),
                  buildTextField('Email', emailController,
                      TextInputType.emailAddress, 'Enter your email'),

                      Row(
                    children: [
                      Expanded(
                        child: buildTextField('Car type', cartypeController,
                            TextInputType.text, 'Enter your Car type'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          margin: const EdgeInsets.only(left: 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: greyColor,
                              size: 35,
                            ),
                            onPressed: _addCarType,
                          ),
                        ),
                      ),
                    ],
                  ),

                  for (var carType in carTypes)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: greyColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                carType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'BahijTheSansArabic',
                                  color: deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                 
                  buildTextField('Location', locationController,
                      TextInputType.text, 'Enter your location'),
                  buildImagePicker('Tax Certificate', _pickImage),
                  buildImagePicker('Commercial Register', _pickImage),
                  buildImagePicker('Municipality Certificate', _pickImage),
                  buildImagesDisplay(),
                  buildAgreementSwitch(),
                  buildSubmitButton(context),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      TextInputType type, String? text) {
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
          labelText: text ?? 'Placeholder',
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

  

  Widget buildImagePicker(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 16,
                      color: greyColor,
                      fontFamily: 'BahijTheSansArabic')),
              SvgPicture.asset('assets/images/gallery.svg',
                  height: 24, width: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImagesDisplay() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16),
      child: Wrap(
        children: List.generate(_images.length, (index) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(_images[index].path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: SvgPicture.asset('assets/images/cancel.svg',
                      width: 24, height: 24),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildAgreementSwitch() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isAgreed = !isAgreed;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SvgPicture.asset(
              isAgreed
                  ? 'assets/images/Object.svg'
                  : 'assets/images/Object1.svg',
              height: 24,
              width: 24,
            ),
          ),
        ),
        Column(
          children: [
            CustomText(
              text: 'Agree to terms and conditions',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
          ),
          child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'),
        ),
        const SizedBox(height: 27),
        CustomButton(
          text: 'Register',
          onPressed: () {
            if (_formKey.currentState!.validate()) {}
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrueScreen(),
                // const CarForm(),
              ),
            );
           
            // showDialog(
            //   context: context,
            //   barrierDismissible:
            //       false, // This ensures the dialog cannot be dismissed by tapping outside
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: const Center(
            //         child: Icon(
            //           Icons.check_circle, // Success icon
            //           color: Colors.green,
            //           size: 60,
            //         ),
            //       ),
            //       content: CustomText(
            //         text: 'You\'re Successfuly Resgister',
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //       ),
            //       actions: <Widget>[
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             CustomButton2(
            //               text: 'Edit',
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //             ),
            //             const SizedBox(height: 7),
            //             CustomButton(
            //               text: 'Home page',
            //               onPressed: () {},
            //             )
            //           ],
            //         ),
            //       ],
            //     );
            //  },
            //);
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
