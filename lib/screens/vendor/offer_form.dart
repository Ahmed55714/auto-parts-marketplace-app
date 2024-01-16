import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work2/constants/colors.dart';
import '../../generated/l10n.dart';
import '../../getx/orders.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import 'Bottom_nav.dart';

class OfferForm extends StatefulWidget {
  final String orderId;
const OfferForm({Key? key, required this.orderId}) : super(key: key);
  @override
  _OfferFormState createState() => _OfferFormState();
}

class _OfferFormState extends State<OfferForm> {
  final OrdersController ordersController = Get.find<OrdersController>();

  bool isAgreed = false;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<List<XFile?>> _images = [[], [], []];

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
      return S.of(context).Offer8;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButtonDeep(),
                    ],
                  ),
                   Text(
                    S.of(context).Offer1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  buildTextField(S.of(context).Offer2, PrieceController, TextInputType.text,
                      S.of(context).Offer2),
                  buildTextField(S.of(context).Offer3, CountryController,
                      TextInputType.text, S.of(context).Offer31),
                  buildTextField(S.of(context).Offer4, ModelController,
                      TextInputType.number, S.of(context).Offer41,),
                  buildCarTypeField(),
                  buildTextField(
                      S.of(context).Offer6, PriceController, TextInputType.number, S.of(context).Offer6),
                  Row(
                    children: [
                      CustomText(
                          text: S.of(context).Offer7,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  buildImagePicker(S.of(context).Offer7, 0),
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

                  Row(
                    children: [
                      buildImagesDisplay(0),
                    ],
                  ),
                  //buildAgreementSwitch(),
                  Row(
                    children: [
                      CustomText(
                          text: S.of(context).Offer9,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                  CustomMultiLineFormField(
                    keyboardType: TextInputType.multiline,
                    labelText: S.of(context).Offers11,
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
          fieldHeight: 100,
          labelText: text,
          controller: controller,
          keyboardType: type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '${S.of(context).Name3} $label';
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
              return '${S.of(context).Name3} $label';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
      ],
    );
  }
List<String> carTypeOptions = ['new', 'used'];
String selectedCarType = 'new'; // default value
 Widget buildCarTypeField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText(
        text: S.of(context).Offer5,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      SizedBox(height: 8),
      GestureDetector(
        onTap: () => _showCarTypeDialog(context),
        child: AbsorbPointer(
          child: CustomTextField(
            labelText: selectedCarType,
            controller: carTypeController..text = selectedCarType,
            keyboardType: TextInputType.text,
            suffixIcon: SvgPicture.asset('assets/images/arrow-down.svg',
                height: 24, width: 24),
          ),
        ),
      ),
      SizedBox(height: 8),
    ],
  );
}

void _showCarTypeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).Offers12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: carTypeOptions.map((String option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                setState(() {
                  selectedCarType = option;
                  carTypeController.text = option;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      );
    },
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
        
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CustomButton(
          text: S.of(context).Offer10,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              List<XFile> images = _images
                  .expand((xFiles) => xFiles)
                  .whereType<XFile>()
                  .toList();

              ordersController.OfferForm(
                orderId: widget.orderId,
                Piece: PrieceController.text,
                country: CountryController.text,
                yearModel: ModelController.text,
                chassisNumber: carTypeController.text,
                condition: selectedCarType, // Add your condition value
                price: PriceController.text,
                notes: noteController.text,
                images:images,
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => Directionality(
                textDirection: TextDirection.ltr,
                child: TrueOfferScreen())) );
            }
            
            // Navigator.pushNamed(context, '/ordersrate');
          },
        ),
      ],
    );
  }
}
