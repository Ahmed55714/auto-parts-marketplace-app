import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../getx/regestration.dart';
import '../../widgets/custom_button.dart';
import 'Registration_form.dart';

class MyMap extends StatefulWidget {
  
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _ClientMapState();
}

class _ClientMapState extends State<MyMap> {
  final RegesterController regesterController = Get.find<RegesterController>();
  late Future<String> _completeRegistrationStatus;
  
  
    @override
  void initState() {
    super.initState();
    _completeRegistrationStatus = fetchCompleteRegistrationStatus();
  }
  
   Future<String> fetchCompleteRegistrationStatus() async {
    var url = Uri.parse('https://slfsparepart.com/api/user');
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['complete_registration'].toString();
        
      } else {
        throw Exception('Failed to load registration status');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
  bool hasVisitedRegistrationScreen = false;

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<String>(
              future: _completeRegistrationStatus,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == "0") {
                  // If registration is not complete, show the map with the button
                  return Column(
                    children: [
                      Expanded(
                        child: const CustomGoogleMap(),
                      ),
                      CustomButton(
                        text: 'Complete Registration',
                        onPressed: () {
                          // Navigate to the registration screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationForm(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  // If registration is complete, just show the map
                  return const Expanded(
                    child: CustomGoogleMap(),
                  );
                }
              },
            ),
            const Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: CustomSearchBar(),
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
            child: SvgPicture.asset('assets/images/filled.svg',
                height: 24, width: 24),
          ),
        ),
      ),
    );
  }
}

// Placeholder for CustomButton


// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// import '../../getx/regestration.dart';
// import '../../widgets/custom_button.dart';
// import 'Registration_form.dart';

// class MyMap extends StatefulWidget {
  
//   const MyMap({super.key});

//   @override
//   State<MyMap> createState() => _ClientMapState();
// }

// class _ClientMapState extends State<MyMap> {
//   final RegesterController regesterController = Get.find<RegesterController>();
//    Future<String> fetchCompleteRegistrationStatus() async {
//     var url = Uri.parse('https://slfsparepart.com/api/user');
//     final prefs = await SharedPreferences.getInstance();
//     final String? authToken = prefs.getString('auth_token');

//     try {
//       var response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         return jsonResponse['complete_registration'].toString();
        
//       } else {
//         throw Exception('Failed to load registration status');
//       }
//     } catch (e) {
//       throw Exception('Error occurred: $e');
//     }
//   }
//   bool hasVisitedRegistrationScreen = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             const CustomGoogleMap(),
//             Column(
//               children: [
//                 const CustomSearchBar(),
//                 Spacer(), // This will push the button to the bottom of the screen
//               ],
//             ),
//            FutureBuilder<String>(
//             future: fetchCompleteRegistrationStatus(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Container(); // Optionally, return a loading indicator
//               } else if (snapshot.hasData && snapshot.data == "0") {
//                 return Positioned(
//                   bottom: 20,
//                   left: 20,
//                   right: 20,
//                   child: CustomButton(
//                     text: 'My Order',
//                     onPressed: () => regesterController.navigateBasedVendor(context),
//                   ),
//                 );
//               } else {
//                 return Container(); // Return an empty container if status is not "1"
//               }
//             },
//           ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomGoogleMap extends StatefulWidget {
//   const CustomGoogleMap({super.key});

//   @override
//   _CustomGoogleMapState createState() => _CustomGoogleMapState();
// }

// class _CustomGoogleMapState extends State<CustomGoogleMap> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final LatLng _initialPosition = const LatLng(37.33500926, -122.03272188);
//   Location _location = Location();
//   LocationData? _currentLocation;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   _getCurrentLocation() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;

//     _serviceEnabled = await _location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await _location.requestService();
//       if (!_serviceEnabled) return;
//     }

//     _permissionGranted = await _location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await _location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) return;
//     }

//     _location.onLocationChanged.listen((LocationData currentLocation) {
//       setState(() {
//         _currentLocation = currentLocation;
//       });

//       if (_controller.isCompleted) {
//         _controller.future.then((controller) {
//           controller.animateCamera(
//             CameraUpdate.newCameraPosition(
//               CameraPosition(
//                 bearing: 0,
//                 target: LatLng(
//                     _currentLocation!.latitude!, _currentLocation!.longitude!),
//                 zoom: 17.0,
//               ),
//             ),
//           );
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentLocation == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return GoogleMap(
//       onMapCreated: (GoogleMapController controller) {
//         _controller.complete(controller);
//       },
//       initialCameraPosition: CameraPosition(
//         target: _initialPosition,
//         zoom: 18.0,
//       ),
//       myLocationEnabled: true,
//       myLocationButtonEnabled: false,
//     );
//   }
// }

// // Placeholder for CustomSearchBar
// class CustomSearchBar extends StatelessWidget {
//   const CustomSearchBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'Search...',
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide.none,
//           ),
//           prefixIcon: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: SvgPicture.asset('assets/images/filled.svg',
//                 height: 24, width: 24),
//           ),
//         ),
//       ),
//     );
//   }
// }
