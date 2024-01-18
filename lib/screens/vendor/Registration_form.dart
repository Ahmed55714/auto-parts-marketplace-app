import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:work2/constants/colors.dart';
import '../../generated/l10n.dart';
import '../../getx/regestration.dart';
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
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<List<XFile?>> _images = [[], [], []];

  // Text editing controllers
  final nameController = TextEditingController();
  //final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final carTypeController = TextEditingController();
  final locationController = TextEditingController();
  final cartypeController = TextEditingController();
  final locationdoneController = TextEditingController();

  List<String> carTypes = []; // List to store car types
  final RegesterController regesterController = Get.find<RegesterController>();
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
    cartypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int fieldIndex) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images[fieldIndex].add(image);
      });
    }
  }

  String? validateField1() {
    if (_images[0].isEmpty || _images[0].any((xFile) => xFile == null)) {
      return S.of(context).AreCancel42;
    }
    return null;
  }

  String? validateField2() {
    if (_images[1].isEmpty || _images[1].any((xFile) => xFile == null)) {
      return S.of(context).AreCancel43;
    }
    return null;
  }

  String? validateField3() {
    if (_images[2].isEmpty || _images[2].any((xFile) => xFile == null)) {
      return S.of(context).AreCancel44;
    }
    return null;
  }

  void _removeImage(int fieldIndex, XFile image) {
    setState(() {
      _images[fieldIndex].remove(image);
    });
  }

  @override
  void initState() {
    super.initState();
    regesterController.fetchCarTypes();
  }

  @override
  Widget build(BuildContext context) {
    var textDirection = Directionality.of(context);

    // Adjust padding based on text direction
    var errorPadding = textDirection == TextDirection.ltr
        ? const EdgeInsets.only(left: 16)
        : const EdgeInsets.only(right: 16);
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
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButtonDeep(),
                        ],
                      ),
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
                  buildTextField(S.of(context).Name, nameController,
                      TextInputType.text, S.of(context).EnterYourName),
                  // buildTextField('Phone Number', phoneNumberController,
                  //     TextInputType.number, 'Enter your phone number'),
                  buildTextField(S.of(context).Profile5, emailController,
                      TextInputType.emailAddress, S.of(context).Enteryouremail),
                  buildCarTypeField1(),
                  const SizedBox(height: 10),

                  buildTextFieldLocation(
                      S.of(context).Location,
                      locationdoneController,
                      locationController,
                      TextInputType.text,
                      S.of(context).EnterYourLocation,
                      context),
                  buildImagePicker(S.of(context).TaxCertificate, 0),

                  if (validateField1() != null)
                    Padding(
                      padding: errorPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(validateField1()!,
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  buildImagePicker(S.of(context).CommercialRegister, 1),

                  if (validateField2() != null)
                    Padding(
                      padding: errorPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(validateField2()!,
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  buildImagePicker(S.of(context).MunicipalityCertificatee, 2),

                  if (validateField3() != null)
                    Padding(
                      padding: errorPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(validateField3()!,
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      buildImagesDisplay(0),
                      buildImagesDisplay(1),
                      buildImagesDisplay(2),
                    ],
                  ),

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

  Widget buildCarTypeField1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: S.of(context).CarType,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (regesterController.isLoading.isTrue) {
            return CircularProgressIndicator();
          } else {
            var carTypeItems = regesterController.carTypes
                .map(
                    (car) => MultiSelectItem(car['id'].toString(), car['name']))
                .toList();

            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: MultiSelectDialogField(
                items: carTypeItems,
                title: Text(S.of(context).CarType),
                selectedColor: deepPurple,
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                    color: deepPurple,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.car_rental,
                  color: deepPurple,
                ),
                buttonText: Text(
                  S.of(context).Offers12,
                  style: TextStyle(
                    color: deepPurple,
                    fontSize: 16,
                  ),
                ),
                onConfirm: (List selectedValues) {
                  setState(() {
                    carTypes = selectedValues.map((e) => e.toString()).toList();
                  });
                },
                initialValue: carTypes.map((e) => e.toString()).toList(),
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return S.of(context).Pleace4;
                  }
                  return null;
                },
              ),
            );
          }
        }),
        const SizedBox(height: 8),
        // Displaying selected car types
      ],
    );
  }

  Widget buildTextFieldLocation(
      String label,
      TextEditingController controller,
      TextEditingController locationController,
      TextInputType type,
      String? text,
      BuildContext context) {
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

  Widget buildImagePicker(String label, int fieldIndex) {
    bool hasImage = _images.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickImage(fieldIndex),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasImage
                      ? Colors.grey
                      : Colors.red, // Red border if no image selected
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: hasImage
                          ? Colors.grey
                          : Colors.red, // Red text if no image selected
                      fontFamily: 'BahijTheSansArabic',
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/gallery.svg',
                    height: 24,
                    width: 24,
                    color: hasImage
                        ? null
                        : Colors.red, // Red icon if no image selected
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImagesDisplay(int fieldIndex) {
    return Wrap(
      children: _images[fieldIndex].map((image) {
        return image != null
            ? Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(image.path),
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
                      onTap: () => _removeImage(fieldIndex, image),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox();
      }).toList(),
    );
  }

  Widget buildAgreementSwitch() {
    var textDirection = Directionality.of(context);

    // Adjust padding based on text direction
    var errorPadding = textDirection == TextDirection.ltr
        ? const EdgeInsets.only(left: 16)
        : const EdgeInsets.only(right: 16);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isAgreed = !isAgreed;
            });
          },
          child: Padding(
            padding: errorPadding,
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
              text: S.of(context).Register2,
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
        Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
          ),
          child: Text(S.of(context).Agreee),
        ),
        const SizedBox(height: 27),
        CustomButton(
          text: S.of(context).Register,
          onPressed: () async {
            if (_formKey.currentState!.validate() &&
                validateField1() == null &&
                validateField2() == null &&
                validateField3() == null) {
              setState(() {
                _isLoading = true; // Start loading
              });

              var latLong = locationController.text.split(',');
              if (latLong.length != 2) {
                // Handle error

                return;
              }
              List<XFile> flattenedImages = _images
                  .expand((xFiles) => xFiles)
                  .where((xFile) => xFile != null)
                  .cast<XFile>()
                  .toList();

              try {
                await regesterController.postVendorRegistration(
                  name: nameController.text,
                  email: emailController.text,
                  carTypeIds: carTypes,
                  latitude: latLong[0].trim(),
                  longitude: latLong[1].trim(),
                  images: flattenedImages,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Directionality(
                        textDirection: TextDirection.ltr, child: TrueScreen()),
                  ),
                );
              } catch (e) {
                // Handle error
              } finally {
                setState(() {
                  _isLoading = false; // Stop loading
                });
              }
            }
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return SizedBox(); // Empty box when not loading
  }
}
