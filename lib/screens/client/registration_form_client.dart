import 'dart:io';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:work2/constants/colors.dart';
import '../../generated/l10n.dart';
import '../../getx/regestration.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'dart:ui' as ui;

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
  final locationdoneController = TextEditingController();

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
  void initState() {
    super.initState();

    final RegesterController regesterController =
        Get.find<RegesterController>();

    // Fetch data once
    regesterController.fetchCarTypes().then((_) {
      if (regesterController.carTypes.isNotEmpty) {
        carTypeController.text =
            regesterController.carTypes.first['id'].toString();
      }
    });
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
                  Text(
                    S.of(context).Registration,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                    S.of(context).Name,
                    nameController,
                    TextInputType.text,
                    S.of(context).EnterYourName,
                  ),
                  buildTextField(S.of(context).Profile5, emailController,
                      TextInputType.emailAddress, S.of(context).Enteryouremail),
                  buildDateFieldDate(
                    S.of(context).Date,
                    dateController,
                  ),
                  buildTextFieldLocation(
                      S.of(context).Location,
                      locationdoneController,
                      locationController,
                      TextInputType.text,
                      S.of(context).EnterYourLocation,
                      context),
                  buildCarTypeField1(
                    S.of(context).CarType,
                    S.of(context).Offers12,
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

  Widget buildCarTypeField1(String text, String hint) {
    final RegesterController regesterController =
        Get.find<RegesterController>();

    return buildDropdownField(text, hint, carTypeController,
        regesterController.isLoading, regesterController.carTypes);
  }

  Widget buildDropdownField(String text, String hint,
      TextEditingController controller, RxBool isLoading, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (isLoading.isTrue) {
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
                      labelText: hint,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                    ),
                    value: controller.text,
                    onChanged: (String? newValue) {
                      controller.text = newValue ?? '';
                    },
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'].toString(),
                        child: Text(item['name']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '${S.of(context).Name3} $text';
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
          labelText: text ?? S.of(context).Placeholder,
          controller: controller,
          keyboardType: type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${S.of(context).Name3} $label';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget buildTextFieldLocation(
    String label,
    TextEditingController controller,
    TextEditingController locationController,
    TextInputType type,
    String? text,
    BuildContext context,
  ) {
    // Function to get current location
    Future<void> _getCurrentLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, handle this case
        return Future.error(S.of(context).registerLocation);
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, handle this case
          return Future.error(S.of(context).registerLocation1);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle this case
        return Future.error(S.of(context).registerLocation2);
      }

      // When permissions are granted, get the current location
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        // Update the locationController with latitude and longitude
        locationController.text = '${position.latitude}, ${position.longitude}';
        // Update the display controller with "Done"
        controller.text = S.of(context).Done;
      });
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
          labelText: text ?? S.of(context).Placeholder,
          suffixIcon: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () => _getCurrentLocation(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${S.of(context).Name3} $label';
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
              labelText: controller.text.isEmpty
                  ? S.of(context).sucess3
                  : controller.text,
              controller: controller,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '${S.of(context).Name3} $label';
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
            text: S.of(context).CarType,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            labelText: S.of(context).Offers12,
            controller: carTypeController,
            keyboardType: TextInputType.text,
            suffixIcon: SvgPicture.asset('assets/images/arrow-down.svg',
                height: 24, width: 24),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '${S.of(context).Name3} ${S.of(context).CarType}';
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
              text: S.of(context).Agreee,
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
        Obx(() {
          if (regesterController.isLoading.value) {
            return CircularProgressIndicator();
          } else {
            return CustomButton(
              text: S.of(context).Register,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String selectedCarTypeId = carTypeController.text;
                  var latLong = locationController.text.split(',');

                  await regesterController.postClientRegistration(
                    name: nameController.text,
                    email: emailController.text,
                    birthDate: dateController.text,
                    carTypeId: selectedCarTypeId,
                    latitude: latLong[0].trim(),
                    longitude: latLong[1].trim(),
                  );

                  if (regesterController.message.value == 'Success') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Directionality(
                            textDirection: ui.TextDirection.ltr,
                            child: TrueresgesterScreen()),
                      ),
                    );
                  } else if (regesterController.message.value.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(regesterController.message.value)),
                    );
                  }
                }
              },
            );
          }
        }),
        const SizedBox(height: 15),
      ],
    );
  }
}
