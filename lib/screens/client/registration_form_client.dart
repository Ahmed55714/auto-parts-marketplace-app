import 'dart:io';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:work2/constants/colors.dart';
import '../../getx/regestration.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'car_form.dart';

class RegistrationFormClinet extends StatefulWidget {
  const RegistrationFormClinet({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationFormClinet> {
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
  final dateController = TextEditingController();
  final cartypeController = TextEditingController();

  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;

  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    // phoneController.dispose();
    emailController.dispose();
    carTypeController.dispose();
    locationController.dispose();
    dateController.dispose();
    cartypeController.dispose();
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
                  buildTextField('Email', emailController,
                      TextInputType.emailAddress, 'Enter your email'),
                  buildDateFieldDate(
                    'Birth date',
                    dateController,
                  ),
                  buildTextFieldLocation('Location', locationController,
                      TextInputType.text, 'Enter your location', context),
                  buildCarTypeField1(),
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

  Widget buildCarTypeField1() {
    final RegesterController regesterController =
        Get.find<RegesterController>();

    // This line will trigger the API call when the widget is being built
    regesterController.fetchCarTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Car type',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (regesterController.isLoading.isTrue) {
            return CircularProgressIndicator();
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Car Type',
                      border: InputBorder.none, // No border
                      // To align the label text and the dropdown arrow icon
                      contentPadding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                    ),
                    value: carTypeController.text.isEmpty
                        ? null
                        : carTypeController.text,
                    onChanged: (String? newValue) {
                      carTypeController.text = newValue ?? '';
                    },
                    items: regesterController.carTypes.map((car) {
                      return DropdownMenuItem<String>(
                        value: car['id'].toString(),
                        child: Text(car['name']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Car type';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            );
          }
        }),
        const SizedBox(height: 8),
      ],
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

  Widget buildTextFieldLocation(String label, TextEditingController controller,
      TextInputType type, String? text, BuildContext context) {
    // Function to get current location
    Future<void> _getCurrentLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, handle this case
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, handle this case
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle this case
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      
      // When permissions are granted, get the current location
      Position position = await Geolocator.getCurrentPosition();
      controller.text = "${position.latitude}, ${position.longitude}";
      
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
        CustomTextField(
          controller: controller,
          keyboardType: type,
          labelText: text ?? 'Placeholder',
          suffixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () => _getCurrentLocation(),
          ),
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

  Widget buildDateFieldDate(String label, TextEditingController controller,
      {String? initialText}) {
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

  Widget buildCarTypeField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Car type',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 8),
        ],
      ),
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
    final RegesterController regesterController =
        Get.find<RegesterController>();
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
          text: 'Register',
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              String selectedCarTypeId = carTypeController.text;
              // Assuming you have latitude and longitude as separate variables
              var latLong = locationController.text.split(',');

              // Call the API to register the client
              await regesterController.postClientRegistration(
                name: nameController.text,
                email: emailController.text,
                birthDate: dateController.text,
                carTypeId: selectedCarTypeId,
                latitude: latLong[0].trim(),
                longitude: latLong[1].trim(),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrueresgesterScreen(),
                  // const CarForm(),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
