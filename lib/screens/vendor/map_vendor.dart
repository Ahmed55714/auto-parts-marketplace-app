import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../widgets/custom_button.dart';
import 'Registration_form.dart';


class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _ClientMapState();
}

class _ClientMapState extends State<MyMap> {
    bool hasVisitedRegistrationScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const CustomGoogleMap(),
            Column(
              children: [
                const CustomSearchBar(),
                Spacer(), // This will push the button to the bottom of the screen
              ],
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CustomButton(
                text: 'Order Now',
                onPressed: () {

                   if (!hasVisitedRegistrationScreen) {
                  // Navigate to the registration screen for the first time
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RegistrationForm(),
                  )).then((result) {
                    // When returning from the registration screen, set the flag
                    // to true to indicate that it has been visited.
                    setState(() {
                      hasVisitedRegistrationScreen = true;
                    });
                  });
                } else {
                  // Navigate to another screen when the button is pressed again.
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => CarForm(),
                  // ));
                }
                 
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  _CustomGoogleMapState createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng _initialPosition = const LatLng(37.33500926, -122.03272188);
  Location _location = Location();
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
      });

      if (_controller.isCompleted) {
        _controller.future.then((controller) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 0,
                target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
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
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      
      
    );
  }
}

// Placeholder for CustomSearchBar
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset('assets/images/filled.svg', height: 24, width: 24),
          ),
        ),
      ),
    );
  }
}

// Placeholder for CustomButton
