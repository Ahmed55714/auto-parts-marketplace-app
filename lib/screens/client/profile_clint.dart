import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';

import '../../getx/update_profile.dart';
import '../../widgets/custom_button.dart';

import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'map_client.dart';
import 'package:http/http.dart' as http;

class ProfileClient extends StatefulWidget {
  const ProfileClient({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<ProfileClient> {
  String? _imageURL;

  List<Address> addresses = [];
  int selectedContainerIndex = -1;

  Future<void> fetchAddresses() async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/user/addresses");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.get(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          addresses = jsonList.map((json) => Address.fromJson(json)).toList();
        });
      } else {
        // Handle error
        print('Failed to fetch addresses');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while fetching addresses: $e');
    }
  }

  Future<void> deleteAddress(int addressId) async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/user/addresses/$addressId/delete");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.post(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        fetchAddresses();
      } else {
        // Handle error
        print('Failed to delete address');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while deleting address: $e');
    }
  }

  Future<void> fetchProfilePic() async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/user"); // Replace with your API endpoint
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.get(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final imageUrl = userData['image_url'];
        setState(() {
          _imageURL = imageUrl; // Store the image URL in a variable.
        });
      } else {
        // Handle error
        print('Failed to fetch user data');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAddresses();
    fetchProfilePic();
  }

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
  final namePlaceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    aptController.dispose();
    namePlaceController.dispose();

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
                              image: NetworkImage(_imageURL ??
                                  'YOUR_DEFAULT_IMAGE_URL_HERE'), // Use the image URL here, or provide a default URL.
                            ),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          bottom: 5,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
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
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        return CustomSelection(
                          index: index,
                          isSelected: selectedContainerIndex == index,
                          title: address.name, // Name from API
                          description:
                              "${address.street} - ${address.building} - ${address.floor} - ${address.apartment}", // Address details from API
                          onTap: () {
                            setState(() {
                              selectedContainerIndex = index;
                            });
                          },
                          addressId: address.id ?? 0,
                          onDelete: () {
                            if (address.id != null) {
                              deleteAddress(address.id);
                            } else {
                              print("Address ID is null.");
                            }
                          },
                        );
                      },
                    ),
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
                        buildTextField(
                            'Name', namePlaceController, TextInputType.text),
                        const SizedBox(height: 16),
                        buildTextField(
                            'Street', streetController, TextInputType.text),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: buildTextField('Building',
                                  buildingController, TextInputType.number),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: buildTextField('Floor', floorController,
                                  TextInputType.number),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        buildTextField(
                            'Apt', aptController, TextInputType.number),
                        const SizedBox(height: 16),
                        CustomButton(
                            text: 'save',
                            onPressed: () async {
                              if (_bottomSheetFormKey.currentState!
                                  .validate()) {
                                await updateController.createAdress(
                                  name: namePlaceController.text,
                                  street: streetController.text,
                                  building: buildingController.text,
                                  floor: floorController.text,
                                  apartment: aptController.text,
                                  lat: 'Latitude from map',
                                  long: 'Longitude from map',
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
          labelText: 'Enter $label',
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

class Address {
  final int id;
  final String name;
  final String street;
  final String building;
  final String floor;
  final String apartment;

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.building,
    required this.floor,
    required this.apartment,
  });

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      street: json['street'],
      building: json['building'],
      floor: json['floor'],
      apartment: json['apartment'],
    );
  }
}

class CustomSelection extends StatefulWidget {
  final int index;
  final bool isSelected;
  final String title;
  final String description;
  final VoidCallback onTap;
  final int addressId;
  final VoidCallback onDelete;

  CustomSelection({
    required this.index,
    required this.isSelected,
    required this.title,
    required this.description,
    required this.onTap,
    required this.addressId,
    required this.onDelete,
  });

  @override
  State<CustomSelection> createState() => _CustomSelectionState();
}

class _CustomSelectionState extends State<CustomSelection> {
  final UpdateProfileController updateController =
      Get.find<UpdateProfileController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected ? deepPurple : greyColor,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: AnimatedContainer(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: widget.isSelected ? deepPurple : greyColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            bottomLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                            bottomRight: Radius.circular(10),
                          )),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      child: Visibility(
                        visible: widget.isSelected,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AnimatedContainer(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 19),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 23),
                              child: Container(
                                width: 150,
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: widget.isSelected
                                        ? deepPurple
                                        : greyColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30, top: 9),
                        child: Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: widget.isSelected ? deepPurple : greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 80.0),
                    child: AnimatedContainer(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: widget.isSelected ? deepPurple : greyColor,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      child: Visibility(
                        visible: widget.isSelected,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AnimatedContainer(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, bottom: 10),
                    child: GestureDetector(
                      onTap: widget.onDelete,
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
            ],
          ),
        ),
      ),
    );
  }
}
