import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work2/constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import 'Bottom_nav.dart';

class OfferForm extends StatefulWidget {
  const OfferForm({Key? key}) : super(key: key);

  @override
  _OfferFormState createState() => _OfferFormState();
}

class _OfferFormState extends State<OfferForm> {
  bool isAgreed = false;
  List<XFile> _images = [];
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers
  final PrieceController = TextEditingController();
  final CountryController = TextEditingController();
  final ModelController = TextEditingController();
  final carTypeController = TextEditingController();
  final PriceController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    PrieceController.dispose();
    CountryController.dispose();
    ModelController.dispose();
    carTypeController.dispose();
    PriceController.dispose();
    noteController.dispose();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButtonDeep(),
                    ],
                  ),
                  const Text(
                    'Offer Form',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  buildTextField('Priece', PrieceController, TextInputType.text,
                      'Placeholder'),
                  buildTextField('Country Made in', CountryController,
                      TextInputType.text, 'Placeholder'),
                  buildTextField('Year Model', ModelController,
                      TextInputType.number, 'Year'),
                  buildCarTypeField(),
                  buildTextField(
                      'Price', PriceController, TextInputType.number, 'Price'),
                  Row(
                    children: [
                      CustomText(
                          text: 'Add photos',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  buildImagePicker('Add photos', _pickImage),
                  // buildImagePicker('Commercial Register', _pickImage),
                  // buildImagePicker('Municipality Certificate', _pickImage),

                  buildImagesDisplay(),
                  //buildAgreementSwitch(),
                  Row(
                    children: [
                      CustomText(
                          text: 'Extra note',
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  CustomMultiLineFormField(
                    keyboardType: TextInputType.multiline,
                    labelText: 'Placeholder',
                    controller: noteController,
                  ),

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
      TextInputType type, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 8),
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
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildCustomMultiLineFormField(String label,
      TextEditingController controller, TextInputType type, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 8),
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
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildCarTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'New/Used',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 8),
        CustomTextField(
          labelText: 'Placeholder',
          controller: carTypeController,
          keyboardType: TextInputType.text,
          suffixIcon: SvgPicture.asset('assets/images/arrow-down.svg',
              height: 24, width: 24),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Car type';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildImagePicker(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
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
        const SizedBox(height: 20),
        CustomButton(
          text: 'Make an Offer',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Handle form submission
            }
            Navigator.pushNamed(context, '/ordersrate');
          },
        ),
      ],
    );
  }
}
