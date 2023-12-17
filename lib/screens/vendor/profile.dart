import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:work2/constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_continer.dart';
import '../../widgets/custom_textFaild.dart';
import 'Bottom_nav.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isAgreed = false;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();

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
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _image == null
                                  ? const AssetImage(
                                      'path/to/placeholder/image')
                                  : FileImage(_image!) as ImageProvider,
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
                          'Adresses',
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
                    onPressed: () {},
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {}
            showDialog(
              context: context,
              barrierDismissible:
                  false, // This ensures the dialog cannot be dismissed by tapping outside
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(
                    child: Icon(
                      Icons.check_circle, // Success icon
                      color: Colors.green,
                      size: 60,
                    ),
                  ),
                  content: CustomText(
                    text: 'You\'re Successfuly Resgistered',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  actions: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton2(
                          text: 'Edit',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 7),
                        CustomButton(
                          text: 'Home page',
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
