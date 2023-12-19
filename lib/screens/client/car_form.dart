// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work2/constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../vendor/Bottom_nav.dart';
import 'offer_requests.dart';

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  bool isAgreed = false;
  final List<XFile> _images = [];
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers
  final NeededController = TextEditingController();
  final typeController = TextEditingController();
  final modelController = TextEditingController();
  final ChassisController = TextEditingController();
  final locationController = TextEditingController();
  final carpieceController = TextEditingController();
  final carDetailsController = TextEditingController();
  final dateController = TextEditingController();
  final placesController = TextEditingController();
  final PaymentController = TextEditingController();
  final partController = TextEditingController();

  @override
  void dispose() {
    NeededController.dispose();
    typeController.dispose();
    modelController.dispose();
    ChassisController.dispose();
    locationController.dispose();
    carpieceController.dispose();
    carDetailsController.dispose();
    dateController.dispose();
    placesController.dispose();
    PaymentController.dispose();
    partController.dispose();
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       BackButtonDeep(),
                    ],
                  ),
                  const Text(
                    'Car Form',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTextField('Needed car piece', NeededController,
                      TextInputType.text, 'Enter the car piece'),
                   buildCarTypeField('Car type', typeController, 
                      'Enter your car type'),
                   buildCarTypeField('Car model', modelController,
                       'Enter your car model'),
                  buildTextField('Chassis number', ChassisController,
                      TextInputType.number, 'Enter your chassis number'),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      'The chassis number reflects the original information of the car and does not reflect any modifications made by the customer to the vehicle.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'BahijTheSansArabic',
                        color: greyColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildCarTypeField(
                      'Car type', carpieceController, 'Enter your car type'),
                  buildCarTypeField('Car Details', carDetailsController,
                      'Enter your car Details'),
                  DateField('Date', '(optional)', dateController,
                      TextInputType.number, 'dd/mm/yy'),
                  buildImagePicker('Car License', _pickImage),
                  buildCarTypeField('Near places', placesController,
                      'choose your near places'),
                  buildCarTypeField('Payment methods', PaymentController,
                      'choose your payment methods'),
                  //buildImagePicker('Commercial Register', _pickImage),
                  //buildImagePicker('Municipality Certificate', _pickImage),
                  buildImagesDisplay(),
                  buildAgreementSwitch(),
                  SizedBox(height: 13),
                  buildCarTypeField('Piece part', partController,
                      'choose your piece part'),
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

  Widget DateField(String label, String label1,
      TextEditingController controller, TextInputType type, String? text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: label,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            CustomText(
              text: label1,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        const SizedBox(height: 8),
        CustomTextField(
          labelText: text ?? 'Placeholder',
          controller: controller,
          keyboardType: type,
          validator: (value) {
            return null;
          
            // if (value == null || value.isEmpty) {
            //   return 'Please enter $label';
            // }
            // return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget buildCarTypeField(
      String text, TextEditingController carpieceController, String text2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        CustomTextField(
          labelText: text2,
          controller: carpieceController,
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
        const SizedBox(height: 0),
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
              text: 'Price offer for governmental entity',
              fontSize: 14,
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
          child: Text(''),
        ),
        CustomButton(
          text: 'Submit',
          onPressed: () {
            if (_formKey.currentState!.validate()) {}
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OfferRequests(),
              ),
            );
            // showDialog(
            //   context: context,
            //   barrierDismissible:
            //       false, 
            //   builder: (BuildContext context) {
            //     return AlertDialog(
            //       title: const Center(
            //         child: Icon(
            //           Icons.check_circle, 
            //           color: Colors.green,
            //           size: 60,
            //         ),
            //       ),
            //       content: CustomText(
            //         text: 'You\'re Successfuly Resgistered',
            //         fontSize: 16,
            //         fontFamily: 'Bahij TheSansArabic',
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
            //   },
            // );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
