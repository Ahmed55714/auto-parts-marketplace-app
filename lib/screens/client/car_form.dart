// // ignore_for_file: library_private_types_in_public_api

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:work2/constants/colors.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textFaild.dart';
// import '../vendor/Bottom_nav.dart';
// import 'offer_requests.dart';

// class CarForm extends StatefulWidget {
//   const CarForm({Key? key}) : super(key: key);

//   @override
//   _CarFormState createState() => _CarFormState();
// }

// class _CarFormState extends State<CarForm> {
//   bool isAgreed = false;
//   final List<XFile> _images = [];
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();

//   // Text editing controllers
//   final NeededController = TextEditingController();
//   final typeController = TextEditingController();
//   final modelController = TextEditingController();
//   final ChassisController = TextEditingController();
//   final locationController = TextEditingController();
//   final carpieceController = TextEditingController();
//   final carDetailsController = TextEditingController();
//   final dateController = TextEditingController();
//   final placesController = TextEditingController();
//   final PaymentController = TextEditingController();
//   final partController = TextEditingController();

//   @override
//   void dispose() {
//     NeededController.dispose();
//     typeController.dispose();
//     modelController.dispose();
//     ChassisController.dispose();
//     locationController.dispose();
//     carpieceController.dispose();
//     carDetailsController.dispose();
//     dateController.dispose();
//     placesController.dispose();
//     PaymentController.dispose();
//     partController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final List<XFile>? pickedImages = await _picker.pickMultiImage();
//     if (pickedImages != null) {
//       setState(() => _images.addAll(pickedImages));
//     }
//   }

//   void _removeImage(int index) {
//     setState(() => _images.removeAt(index));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Column(
//                 children: [
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                        BackButtonDeep(),
//                     ],
//                   ),
//                   const Text(
//                     'Car Form',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: deepPurple,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   buildTextField('Needed car piece', NeededController,
//                       TextInputType.text, 'Enter the car piece'),
//                    buildCarTypeField('Car type', typeController,
//                       'Enter your car type'),
//                    buildCarTypeField('Car model', modelController,

//                        'Enter your car model'),
//                   buildTextField('Chassis number', ChassisController,
//                       TextInputType.number, 'Enter your chassis number'),
//                   const Padding(
//                     padding: EdgeInsets.only(left: 16, right: 16),
//                     child: Text(
//                       'The chassis number reflects the original information of the car and does not reflect any modifications made by the customer to the vehicle.',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w300,
//                         fontFamily: 'BahijTheSansArabic',
//                         color: greyColor,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   buildCarTypeField(
//                       'Piece type', carpieceController, 'Enter your Piece type'),
//                   buildCarTypeField('Piece Details', carDetailsController,
//                       'Enter your Piece Details'),
//                   DateField('Date', '(optional)', dateController,
//                       TextInputType.number, 'dd/mm/yy'),
//                   buildImagePicker('Car License', _pickImage),
//                   buildCarTypeField('Near places', placesController,
//                       'choose your near places'),

//                   //buildImagePicker('Commercial Register', _pickImage),
//                   //buildImagePicker('Municipality Certificate', _pickImage),
//                   buildImagesDisplay(),
//                   buildAgreementSwitch(),
//                   SizedBox(height: 13),
//                   buildSubmitButton(context),
//                   const SizedBox(height: 15),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(String label, TextEditingController controller,
//       TextInputType type, String? text) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           text: label,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//         const SizedBox(height: 8),
//         CustomTextField(
//           labelText: text ?? 'Placeholder',
//           controller: controller,
//           keyboardType: type,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter $label';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget DateField(String label, String label1,
//       TextEditingController controller, TextInputType type, String? text) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             CustomText(
//               text: label,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//             CustomText(
//               text: label1,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         CustomTextField(
//           labelText: text ?? 'Placeholder',
//           controller: controller,
//           keyboardType: type,
//           validator: (value) {
//             return null;

//             // if (value == null || value.isEmpty) {
//             //   return 'Please enter $label';
//             // }
//             // return null;
//           },
//         ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget buildCarTypeField(
//       String text, TextEditingController carpieceController, String text2, TextInputType type) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           text: text,
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//         ),
//         const SizedBox(height: 8),
//         CustomTextField(
//           labelText: text2,
//           controller: carpieceController,

//           keyboardType: type,
//           suffixIcon: SvgPicture.asset('assets/images/arrow-down.svg',
//               height: 24, width: 24),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter Car type';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 0),
//       ],
//     );
//   }

//   Widget buildImagePicker(String label, VoidCallback onTap,) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.grey),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(label,
//                   style: const TextStyle(
//                       fontSize: 16,
//                       color: greyColor,
//                       fontFamily: 'BahijTheSansArabic')),
//               SvgPicture.asset('assets/images/gallery.svg',
//                   height: 24, width: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildImagesDisplay() {
//     return Padding(
//       padding: const EdgeInsets.only(right: 16.0, left: 16),
//       child: Wrap(
//         children: List.generate(_images.length, (index) {
//           return Stack(
//             alignment: Alignment.topRight,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.file(
//                     File(_images[index].path),
//                     width: 100,
//                     height: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: GestureDetector(
//                   onTap: () => _removeImage(index),
//                   child: SvgPicture.asset('assets/images/cancel.svg',
//                       width: 24, height: 24),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Widget buildAgreementSwitch() {
//     return Row(
//       children: [
//         InkWell(
//           onTap: () {
//             setState(() {
//               isAgreed = !isAgreed;
//             });
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left: 16),
//             child: SvgPicture.asset(
//               isAgreed
//                   ? 'assets/images/Object.svg'
//                   : 'assets/images/Object1.svg',
//               height: 24,
//               width: 24,
//             ),
//           ),
//         ),
//         Column(
//           children: [
//             CustomText(
//               text: 'Price offer for governmental entity',
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget buildSubmitButton(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         const Padding(
//           padding: EdgeInsets.only(
//             left: 16.0,
//             right: 16,
//           ),
//           child: Text(''),
//         ),
//         CustomButton(
//           text: 'Submit',
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {}
//              Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const OfferRequests(),
//               ),
//             );
//             // showDialog(
//             //   context: context,
//             //   barrierDismissible:
//             //       false,
//             //   builder: (BuildContext context) {
//             //     return AlertDialog(
//             //       title: const Center(
//             //         child: Icon(
//             //           Icons.check_circle,
//             //           color: Colors.green,
//             //           size: 60,
//             //         ),
//             //       ),
//             //       content: CustomText(
//             //         text: 'You\'re Successfuly Resgistered',
//             //         fontSize: 16,
//             //         fontFamily: 'Bahij TheSansArabic',
//             //         fontWeight: FontWeight.w500,
//             //       ),
//             //       actions: <Widget>[
//             //         Column(
//             //           mainAxisAlignment: MainAxisAlignment.center,
//             //           children: [
//             //             CustomButton2(
//             //               text: 'Edit',
//             //               onPressed: () {
//             //                 Navigator.of(context).pop();
//             //               },
//             //             ),
//             //             const SizedBox(height: 7),
//             //             CustomButton(
//             //               text: 'Home page',
//             //               onPressed: () {},
//             //             )
//             //           ],
//             //         ),
//             //       ],
//             //     );
//             //   },
//             // );
//           },
//         ),
//         const SizedBox(height: 15),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:work2/constants/colors.dart';
import '../../getx/orders.dart';
import '../../getx/regestration.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'Bottom_nav.dart';

class CarForm extends StatefulWidget {
  const CarForm({Key? key}) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  bool isAgreed = false;
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
      return 'Please upload an image for license';
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
                    'Car Form',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTextField('needed car piece', pieceCarController,
                      TextInputType.text, 'Enter your car piece'),
                  buildTextField('Car model', carModelController,
                      TextInputType.number, 'Enter your car piece'),
                  buildCarTypeField1('Car type', 'Enter your car type'),
                  buildTextField('Chassis number', chassisNumberController,
                      TextInputType.emailAddress, 'Enter your Chassis number'),
                buildPieceTypeField1(
                  'Piece type',
                  'Enter your Piece type',
                ),
                  const SizedBox(height: 10),
                  buildPieceDetails(
                    'Piece Details',
                    'Enter your Piece Details',
                  ),
                  SizedBox(height: 10),
                  buildDateFieldDate(
                    'Date',
                    dateController,
                    initialText: '2021-01-01',
                  ),

                  buildImagePicker('Car License', 0),

                  if (validateField1() != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
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
                      'Location',
                      locationdoneController,
                      locationController,
                      TextInputType.text,
                      'Enter your location',
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
@override
void initState() {
  super.initState();
  final RegesterController regesterController = Get.find<RegesterController>();
  final OrdersController ordersController = Get.find<OrdersController>();

  // Fetch data once
  regesterController.fetchCarTypes().then((_) {
    if (regesterController.carTypes.isNotEmpty) {
      carTypeController.text = regesterController.carTypes.first['id'].toString();
    }
  });

  ordersController.fetchPieceTypes().then((_) {
    if (ordersController.PieceTypes.isNotEmpty) {
      piecetypeController.text = ordersController.PieceTypes.first['id'].toString();
    }
  });

  ordersController.fetchPieceDeltals().then((_) {
    if (ordersController.PieceDeltals.isNotEmpty) {
      piecedetailsController.text = ordersController.PieceDeltals.first['id'].toString();
    }
  });
}

Widget buildCarTypeField1(String text, String hint) {
  final RegesterController regesterController = Get.find<RegesterController>();

  return buildDropdownField(text, hint, carTypeController, regesterController.isLoading, regesterController.carTypes);
}

Widget buildPieceTypeField1(String text, String hint) {
  final OrdersController ordersController = Get.find<OrdersController>();

  return buildDropdownField(text, hint, piecetypeController, ordersController.isLoading, ordersController.PieceTypes);
}

Widget buildPieceDetails(String text, String hint) {
  final OrdersController detailsController = Get.find<OrdersController>();

  return buildDropdownField(text, hint, piecedetailsController, detailsController.isLoading, detailsController.PieceDeltals);
}

Widget buildDropdownField(String text, String hint, TextEditingController controller, RxBool isLoading, List<dynamic> items) {
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
                      return 'Please enter $text';
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

  // Widget buildCarTypeField1(String text, String hint) {
  //   final RegesterController regesterController =
  //       Get.find<RegesterController>();

  //   // This line will trigger the API call when the widget is being built
  //   regesterController.fetchCarTypes();

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomText(
  //         text: text,
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       const SizedBox(height: 8),
  //       Obx(() {
  //         if (regesterController.isLoading.isTrue) {
  //           return CircularProgressIndicator();
  //         } else {
  //           return Padding(
  //             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 10),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 border: Border.all(color: Colors.grey.shade300),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButtonFormField<String>(
  //                   decoration: InputDecoration(
  //                     labelText: hint,
  //                     border: InputBorder.none, // No border
  //                     // To align the label text and the dropdown arrow icon
  //                     contentPadding: EdgeInsets.fromLTRB(0, 9, 0, 0),
  //                   ),
  //                   value: carTypeController.text,
                      
  //                   onChanged: (String? newValue) {
  //                     carTypeController.text = newValue ?? '';
  //                   },
  //                   items: regesterController.carTypes.map((car) {
  //                     return DropdownMenuItem<String>(
  //                       value: car['id'].toString(),
  //                       child: Text(car['name']),
  //                     );
  //                   }).toList(),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter Car type';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //       }),
  //       const SizedBox(height: 8),
  //     ],
  //   );
  // }
  //  Widget buildPieceTypeField1(String text, String hint) {
  //   final OrdersController ordersController =
  //       Get.find<OrdersController>();

  //   ordersController.fetchPieceTypes();

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomText(
  //         text: text,
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       const SizedBox(height: 8),
  //       Obx(() {
  //         if (ordersController.isLoading.isTrue) {
  //           return CircularProgressIndicator();
  //         } else {
  //           return Padding(
  //             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 10),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 border: Border.all(color: Colors.grey.shade300),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButtonFormField<String>(
  //                   decoration: InputDecoration(
  //                     labelText: hint,
  //                     border: InputBorder.none, // No border
  //                     // To align the label text and the dropdown arrow icon
  //                     contentPadding: EdgeInsets.fromLTRB(0, 9, 0, 0),
  //                   ),
  //                   value: carTypeController.text.isEmpty
  //                       ? null
  //                       : carTypeController.text,
  //                   onChanged: (String? newValue) {
  //                     carTypeController.text = newValue ?? '';
  //                   },
  //                   items: ordersController.PieceTypes.map((piece) {
  //                     return DropdownMenuItem<String>(
  //                       value: piece['id'].toString(),
  //                       child: Text(piece['name']),
  //                     );
  //                   }).toList(),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter Piece type';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //       }),
  //       const SizedBox(height: 8),
  //     ],
  //   );
  // }


  // Widget buildPieceDetails(String text, String hint) {
  //   final OrdersController detailsController =
  //       Get.find<OrdersController>();

  //   detailsController.fetchPieceDeltals();

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       CustomText(
  //         text: text,
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //       ),
  //       const SizedBox(height: 8),
  //       Obx(() {
  //         if (detailsController.isLoading.isTrue) {
  //           return CircularProgressIndicator();
  //         } else {
  //           return Padding(
  //             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 10),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 border: Border.all(color: Colors.grey.shade300),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButtonFormField<String>(
  //                   decoration: InputDecoration(
  //                     labelText: hint,
  //                     border: InputBorder.none, // No border
  //                     // To align the label text and the dropdown arrow icon
  //                     contentPadding: EdgeInsets.fromLTRB(0, 9, 0, 0),
  //                   ),
  //                   value: carTypeController.text.isEmpty
  //                       ? null
  //                       : carTypeController.text,
  //                   onChanged: (String? newValue) {
  //                     carTypeController.text = newValue ?? '';
  //                   },
  //                   items: detailsController.PieceDeltals.map((piece) {
  //                     return DropdownMenuItem<String>(
  //                       value: piece['id'].toString(),
  //                       child: Text(piece['name']),
  //                     );
  //                   }).toList(),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter Piece type';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //       }),
  //       const SizedBox(height: 8),
  //     ],
  //   );
  // }

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
      setState(() {
        // Update the locationController with latitude and longitude
        locationController.text = '${position.latitude}, ${position.longitude}';
        // Update the display controller with "Done"
        controller.text = 'Done';
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
              text: 'Price offer for governmental entity ',
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
        const Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
          ),
          child: Text(
              ''),
        ),
        const SizedBox(height: 27),
        CustomButton(
          text: 'Order',
          onPressed: () async {
            if (_formKey.currentState!.validate() && validateField1() == null) {
              setState(() {
                _isLoading = true; // Start loading
              });

              var latLong = locationController.text.split(',');
              if (latLong.length != 2) {
                // Handle error
                print('Invalid location format');
                return;
              }

             try {
          await ordersController.carFormClient(
            carPiece: pieceCarController.text,
            carTypeIds: [carTypeController.text], // Assuming single selection
            carModelIds: carModelController.text,
            chassisNumber: chassisNumberController.text,
            pieceType: [piecetypeController.text], // Assuming single selection
            pieceDetail: [piecedetailsController.text], // Assuming single selection
            images: _images.expand((xFiles) => xFiles).whereType<XFile>().toList(),
            birthDate: dateController.text,
            latitude: latLong[0].trim(),
            longitude: latLong[1].trim(),
            for_government: isAgreed ? "1" : "0",
          );
               

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrueOrderClinetScreen(),
                  ),
                );
              } catch (e) {
                // Handle error
                print(e);
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
