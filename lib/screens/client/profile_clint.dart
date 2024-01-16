import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';

import '../../generated/l10n.dart';
import '../../getx/update_profile.dart';
import '../../widgets/custom_button.dart';

import '../../widgets/custom_textFaild.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import '../vendor/profile.dart';
import 'package:http/http.dart' as http;

class ProfileClient extends StatefulWidget {
  const ProfileClient({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<ProfileClient> {
  String? _imageURL;

  LatLng? _selectedLocation;
  List<Address> addresses = [];
  int selectedContainerIndex = -1;
  String? _selectedAddressId;

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

          if (addresses.isNotEmpty) {
            selectContainer(0);
          }
        });
      } else {}
    } catch (e) {}
  }

  void selectContainer(int index) {
    setState(() {
      selectedContainerIndex = index;
      if (index != -1) {
        saveAddress(
            addresses[index].fullAddress, addresses[index].id.toString());
      }
    });
  }

  Future<void> saveAddress(String address, String addressId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_address', address);
    await prefs.setString(
        'selected_address_id', addressId); // Save the address ID
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
      }
    } catch (e) {}
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
        final _phoneNumber = userData['phone'];
        setState(() {
          _imageURL = imageUrl;
          phoneNumberController.text = _phoneNumber ?? '';
        });
      } else {
        // Handle error
      }
    } catch (e) {}
  }

  void _onLocationSelected(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAddresses().then((_) {
      if (addresses.isNotEmpty) {
        selectContainer(0);
      }
    });
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

  void refreshAddresses() {
    fetchAddresses();
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
                    S.of(context).Profile,
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
                              image: _image != null
                                  ? FileImage(
                                      _image!) // Display the selected image
                                  : (_imageURL != null
                                          ? NetworkImage(
                                              _imageURL!) // Display the network image if URL is available
                                          : AssetImage(
                                              'YOUR_DEFAULT_IMAGE_PATH'))
                                      as ImageProvider, // Fallback to a default image
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
                   Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          S.of(context).Profile2,
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
                  buildTextField(S.of(context).Profile3, nameController, TextInputType.text),
                  buildTextField(S.of(context).Profile4, phoneNumberController,
                      TextInputType.number),
                  buildTextField(
                      S.of(context).Profile5, emailController, TextInputType.emailAddress),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          S.of(context).Profile6,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  addresses.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            S.of(context).Profile10,
                            style: TextStyle(
                              fontSize: 16,
                              color: deepPurple,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 250,
                          child: ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];
                              return CustomSelection(
                                index: index,
                                isSelected: selectedContainerIndex == index,
                                title: address.name,
                                description:
                                    "${address.street} - ${address.building} - ${address.floor} - ${address.apartment}",
                                onTap: () {
                                  selectContainer(index);
                                },
                                addressId: address.id ?? 0,
                                onDelete: () {
                                  if (address.id != null) {
                                    deleteAddress(address.id);
                                  } else {}
                                },
                              );
                            },
                          ),
                        ),
                  CustomButtongrey(
                    text: S.of(context).Profile8,
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
                       Text(
                        S.of(context).Edit,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: deepPurple),
                      ),
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
                            child: CustomGoogleMappp(
                              onLocationSelected: _onLocationSelected,
                            ),
                          ),
                        ),
                        buildTextField(
                            S.of(context).Profile3, namePlaceController, TextInputType.text),
                        const SizedBox(height: 16),
                        buildTextField(
                            S.of(context).Edit2, streetController, TextInputType.text),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: buildTextField(S.of(context).Edit3,
                                  buildingController, TextInputType.number),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: buildTextField(S.of(context).Edit4, floorController,
                                  TextInputType.number),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        buildTextField(
                            S.of(context).Edit5, aptController, TextInputType.number),
                        const SizedBox(height: 16),
                        CustomButton(
                            text: S.of(context).Profile9,
                            onPressed: () async {
                              if (_bottomSheetFormKey.currentState!
                                  .validate()) {
                                await updateController.createAdress(
                                  name: namePlaceController.text,
                                  street: streetController.text,
                                  building: buildingController.text,
                                  floor: floorController.text,
                                  apartment: aptController.text,
                                  lat: _selectedLocation!.latitude.toString()??'Latitude from map',
                                  long: _selectedLocation!.longitude.toString()??'Longitude from map',
                                  //'Longitude from map',
                                );
                                Navigator.pop(context);
                                refreshAddresses();
                                setState(() {
                                  fetchAddresses();
                                });
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
          labelText: '${S.of(context).Name2} $label',
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
          text: S.of(context).Profile9,
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await updateController.updateProfile(
                name: nameController.text,
                email: emailController.text,
                phone: phoneNumberController.text,
                image: _image,
              );
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    updateTrueScreen(name: nameController.text),
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'], // Assuming 'id' is an integer in your JSON
      name: json['name'] as String,
      street: json['street'] as String,
      building: json['building'].toString(), // Convert to String if it's not
      floor: json['floor'].toString(), // Convert to String if it's not
      apartment: json['apartment'].toString(), // Convert to String if it's not
    );
  }

  String get fullAddress => "$street - $building - $floor - $apartment";
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
                      child: Text(
                        S.of(context).Profile7,
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

class CustomGoogleMappp extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const CustomGoogleMappp({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _CustomGoogleMapppState createState() => _CustomGoogleMapppState();
}

class _CustomGoogleMapppState extends State<CustomGoogleMappp> {
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng _initialPosition = const LatLng(37.33500926, -122.03272188);
  Location _location = Location();
  LocationData? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint));
    });
    widget.onLocationSelected(
        tappedPoint); // Call the callback with the new location
  }

  _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
        _markers.add(
          Marker(
            markerId: MarkerId(_initialPosition.toString()),
            position: _initialPosition,
          ),
        );
      });

      if (_controller.isCompleted) {
        _controller.future.then((controller) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 0,
                target: LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!),
                zoom: 17.0,
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 18.0,
      ),
      markers: _markers, // Use the _markers set here
      onTap: _handleTap, // Add tap functionality
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
    );
  }
}
