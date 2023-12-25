import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work2/constants/colors.dart';
import '../../getx/regestration.dart';
import '../../getx/update_profile.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_continer.dart';
import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'map_client.dart';

class ProfileClient extends StatefulWidget {
  const ProfileClient({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<ProfileClient> {
  bool isAgreed = false;
  final UpdateProfileController updateController =
      Get.put(UpdateProfileController());

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final streetController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();
  final aptController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    aptController.dispose();

    super.dispose();
  }

  File? _image;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  int selectedContainerIndex = -1;
  void selectContainer(int index) {
    setState(() {
      selectedContainerIndex = (selectedContainerIndex == index) ? -1 : index;
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
                    'Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: getImage,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.deepPurple, width: 2),
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/pic.jpg'),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          bottom: 5,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/edit-2.svg',
                              height: 15,
                              width: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Personal data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildTextField('Name', nameController, TextInputType.text),
                  buildTextField('Phone Number', phoneNumberController,
                      TextInputType.number),
                  buildTextField(
                      'Email', emailController, TextInputType.emailAddress),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Addresses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomSelection(
                    index: 0,
                    isSelected: selectedContainerIndex == 0,
                    title: "Home",
                    description: "ST - Building - Floor",
                    onTap: () {
                      selectContainer(0);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 16, bottom: 30),
                        child: GestureDetector(
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: deepPurple,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 16, bottom: 30),
                        child: GestureDetector(
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomSelection(
                    index: 1,
                    isSelected: selectedContainerIndex == 1,
                    title: "Home",
                    description: "ST - Building - Floor",
                    onTap: () {
                      selectContainer(1);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 16, bottom: 30),
                        child: GestureDetector(
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: deepPurple,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 16, bottom: 30),
                        child: GestureDetector(
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomButtongrey(
                    text: '+ Add address',
                    onPressed: () {
                      _showEditAddressBottomSheet(context);
                    },
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

  void _showEditAddressBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _bottomSheetFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          builder: (_, controller) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _bottomSheetFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Edit Address',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: deepPurple),
                      ),
                      // Use an empty container to center the title if there is no right-side icon.
                      Container(width: 48, height: 48),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            height: 200,
                            color: Colors.grey[300], // Placeholder for the map
                            child: const CustomGoogleMap(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        buildTextField(
                            'Street', streetController, TextInputType.text),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: buildTextField('Building',
                                  buildingController, TextInputType.text),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: buildTextField(
                                  'Floor', floorController, TextInputType.text),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: buildTextField(
                                  'Apt', aptController, TextInputType.text),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                            text: 'save',
                            onPressed: () async {
                              if (_bottomSheetFormKey.currentState!
                                  .validate()) {
                                await updateController.createAdress(
                                  name:
                                      'Name from some input if necessary', // If you need the name from the user input, make sure to include it here
                                  street: streetController.text,
                                  building: buildingController.text,
                                  floor: floorController.text,
                                  apartment: aptController.text,
                                  lat:
                                      'Latitude from map', // If you need the latitude from a map widget, make sure to retrieve it
                                  long:
                                      'Longitude from map', // If you need the longitude from a map widget, make sure to retrieve it
                                );

                                // Once the API call is done, hide the loading indicator
                                Navigator.pop(
                                    context); // Pop the loading dialog
                                Navigator.pop(context); // Pop the bottom sheet
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, TextInputType type) {
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
          labelText: 'Placeholder',
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
        const SizedBox(height: 27),
        CustomButton(
          text: 'Save',
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await updateController.updateProfile(
                name: nameController.text,
                email: emailController.text,
                phone: phoneNumberController.text,
              );
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => updateTrueScreen(),
                // const CarForm(),
              ),
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
