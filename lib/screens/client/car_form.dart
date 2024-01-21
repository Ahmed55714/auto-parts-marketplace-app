import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:work2/constants/colors.dart';
import '../../generated/l10n.dart';
import '../../getx/orders.dart';
import '../../getx/regestration.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'payment_offer_check.dart';
import 'dart:ui' as ui;

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  int isAgreed = 0;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<List<XFile?>> _images = [[], [], []];

  // Text editing controllers
  final pieceCarController = TextEditingController();
  final carTypeController = TextEditingController();
  final carModelController = TextEditingController();
  final chassisNumberController = TextEditingController();
  final locationController = TextEditingController();
  final piecetypeController = TextEditingController();
  final piecedetailsController = TextEditingController();
  final dateController = TextEditingController();
  final locationdoneController = TextEditingController();

  @override
  void dispose() {
    pieceCarController.dispose();
    carTypeController.dispose();
    carModelController.dispose();
    chassisNumberController.dispose();
    locationController.dispose();
    piecetypeController.dispose();
    piecedetailsController.dispose();
    dateController.dispose();
    locationdoneController.dispose();

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
      return S.of(context).AreCancel8;
    }
    return null;
  }

  void _removeImage(int fieldIndex, XFile image) {
    setState(() {
      _images[fieldIndex].remove(image);
    });
  }

  @override
  Widget build(BuildContext context) {
     var textDirection = Directionality.of(context);

  // Adjust padding based on text direction
  var errorPadding = textDirection == ui.TextDirection.ltr
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
                      textDirection: ui.TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButtonDeep(),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).CarForm,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(S.of(context).Needed, pieceCarController,
                      TextInputType.text, S.of(context).CarForm2),
                  buildTextField(S.of(context).CarModel, carModelController,
                      TextInputType.number, S.of(context).CarForm3),
                  buildCarTypeField1(
                      S.of(context).CarType, S.of(context).CarForm5),
                  buildTextField(S.of(context).Chassis, chassisNumberController,
                      TextInputType.emailAddress, S.of(context).CarForm4),
                  buildPieceTypeField1(
                    S.of(context).CarForm8,
                    S.of(context).CarForm5,
                  ),
                  const SizedBox(height: 10),
                  buildPieceDetails(
                    S.of(context).CarForm9,
                    S.of(context).CarForm6,
                  ),
                  SizedBox(height: 10),
                  buildDateFieldDate(
                    S.of(context).Date,
                    dateController,
                  ),
                  buildImagePicker(S.of(context).carLicence, 0),
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
                  Row(
                    children: [
                      buildImagesDisplay(0),
                      buildImagesDisplay(1),
                    ],
                  ),
                  buildTextFieldLocation(
                      S.of(context).Location,
                      locationdoneController,
                      locationController,
                      TextInputType.text,
                      S.of(context).EnterYourLocation,
                      context),
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

  @override
  void initState() {
    super.initState();
    final RegesterController regesterController =
        Get.find<RegesterController>();
    final OrdersController ordersController = Get.find<OrdersController>();

    // Fetch data once
    regesterController.fetchCarTypes().then((_) {
      if (regesterController.carTypes.isNotEmpty) {
        carTypeController.text =
            regesterController.carTypes.first['id'].toString();
      }
    });

    ordersController.fetchPieceTypes().then((_) {
      if (ordersController.PieceTypes.isNotEmpty) {
        piecetypeController.text =
            ordersController.PieceTypes.first['id'].toString();
      }
    });

    ordersController.fetchPieceDeltals().then((_) {
      if (ordersController.PieceDeltals.isNotEmpty) {
        piecedetailsController.text =
            ordersController.PieceDeltals.first['id'].toString();
      }
    });
  }

  Widget buildCarTypeField1(String text, String hint) {
    final RegesterController regesterController =
        Get.find<RegesterController>();

    return buildDropdownField(text, hint, carTypeController,
        regesterController.isLoading, regesterController.carTypes);
  }

  Widget buildPieceTypeField1(String text, String hint) {
    final OrdersController ordersController = Get.find<OrdersController>();

    return buildDropdownField(text, hint, piecetypeController,
        ordersController.isLoading, ordersController.PieceTypes);
  }

  Widget buildPieceDetails(String text, String hint) {
    final OrdersController detailsController = Get.find<OrdersController>();

    return buildDropdownField(text, hint, piecedetailsController,
        detailsController.isLoading, detailsController.PieceDeltals);
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
            // Show loading indicator when data is being fetched
            return Center(child: CircularProgressIndicator());
          } else {
            // Ensure controller's text matches one of the items, or is null
            String? dropdownValue =
                items.any((item) => item['id'].toString() == controller.text)
                    ? controller.text
                    : null;

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
                    value: dropdownValue,
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
                        return '${S.of(context).valid4} $text';
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
        return Future.error(S.of(context).registerLocation1);
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
      if (!mounted) return;
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
    bool hasImage = _images.isNotEmpty; // Check if images list is not empty

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
  var errorPadding = textDirection == ui.TextDirection.ltr
      ? const EdgeInsets.only(left: 16)
      : const EdgeInsets.only(right: 16);
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isAgreed =
                  isAgreed == 0 ? 1 : 0; // Toggle isAgreed between 0 and 1
            });
          },
          child: Padding(
            padding: errorPadding,
            child: SvgPicture.asset(
              isAgreed == 1
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
              text: S.of(context).governmental,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    final OrdersController ordersController = Get.find<OrdersController>();

    return Column(
      children: [
        const SizedBox(height: 10),
        if (isAgreed == 0)
          CustomButton(
            text: S.of(context).Orders,
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  validateField1() == null) {
                setState(() {
                  _isLoading = true; // Start loading
                });

                var latLong = locationController.text.split(',');
                if (latLong.length != 2) {
                  // Handle error

                  return;
                }
                try {
                  await ordersController.carFormClient(
                    carPiece: pieceCarController.text,
                    carTypeIds: [
                      carTypeController.text
                    ], // Assuming single selection
                    carModelIds: carModelController.text,
                    chassisNumber: chassisNumberController.text,
                    pieceType: [
                      piecetypeController.text
                    ], // Assuming single selection
                    pieceDetail: [
                      piecedetailsController.text
                    ], // Assuming single selection
                    images: _images
                        .expand((xFiles) => xFiles)
                        .whereType<XFile>()
                        .toList(),
                    birthDate: dateController.text,
                    latitude: latLong[0].trim(),
                    longitude: latLong[1].trim(),
                    for_government: "0",
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Directionality(
                          textDirection: ui.TextDirection.ltr,
                          child: TrueOrderClinetScreen()),
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
        if (isAgreed == 1)
          CustomButton(
            text: S.of(context).button,
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  validateField1() == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentOfferCheck(
                      carPiece: pieceCarController.text,
                      carTypeIds: [carTypeController.text],
                      carModelIds: carModelController.text,
                      chassisNumber: chassisNumberController.text,
                      pieceType: [piecetypeController.text],
                      pieceDetail: [piecedetailsController.text],
                      images: _images
                          .expand((xFiles) => xFiles)
                          .whereType<XFile>()
                          .toList(),
                      birthDate: dateController.text,
                      latitude: locationController.text.split(',')[0].trim(),
                      longitude: locationController.text.split(',')[1].trim(),
                      forGovernment: "1",
                    ),
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
