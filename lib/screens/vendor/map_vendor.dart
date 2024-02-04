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
import '../client/map_client.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _ClientMapState();
}

class _ClientMapState extends State<MyMap> {
  final RegesterController regesterController = Get.find<RegesterController>();
  late Future<String> _completeRegistrationStatus;
  late Future<List<PersonLocation>> _locationsFuture;

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
  Future<List<PersonLocation>> fetchLocations() async {
    final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/map");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    if (authToken == null) {
      print("Auth token is null");
      return [];
    }

    try {
      final response = await http.get(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        print(authToken);
        print(response.body);
        List<dynamic> data = jsonDecode(response.body);
        return data.map<PersonLocation>((locationJson) {
          return PersonLocation.fromJson(locationJson);
        }).toList();
      } else {
        print('Failed to fetch locations');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching locations: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _completeRegistrationStatus = fetchCompleteRegistrationStatus();
    _locationsFuture = fetchLocations();
  }

  void refreshState() {
    setState(() {
      _completeRegistrationStatus = fetchCompleteRegistrationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _completeRegistrationStatus,
          builder: (context, registrationSnapshot) {
            if (registrationSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (registrationSnapshot.hasError) {
              return Center(
                  child: Text('please check you internet'));
            } else if (registrationSnapshot.hasData &&
                registrationSnapshot.data == "0") {
              // If registration is not complete
              return Stack(
                children: [
                  FutureBuilder<List<PersonLocation>>(
                    future: _locationsFuture,
                    builder: (context, locationsSnapshot) {
                      if (locationsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (locationsSnapshot.hasError) {
                        return Center(
                            child: Text('please check you internet'));
                      } else if (locationsSnapshot.hasData &&
                          locationsSnapshot.data!.isEmpty) {
                        
                          fetchLocations();
                      
                        return CustomGoogleMapp();
                      } else {
                        
                          fetchLocations();
                        
                        return CustomGoogleMap(
                            locations: locationsSnapshot.data!);
                      }
                    },
                  ),
                
                ],
              );
            } else {
              // If registration is complete, just show the map
              return FutureBuilder<List<PersonLocation>>(
                future: _locationsFuture,
                builder: (context, locationsSnapshot) {
                  if (locationsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (locationsSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${locationsSnapshot.error}'));
                  } else if (locationsSnapshot.hasData) {
                    return CustomGoogleMap(locations: locationsSnapshot.data!);
                  } else {
                    return Text('No data available');
                  }
                },
              );
            }
          },
        ),
      ),
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
class CustomGoogleMapp extends StatefulWidget {
  const CustomGoogleMapp({Key? key}) : super(key: key);

  @override
  _CustomGoogleMappState createState() => _CustomGoogleMappState();
}

class _CustomGoogleMappState extends State<CustomGoogleMapp> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location _location = Location();
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
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

      _updateCameraPosition();
    });
  }

  void _updateCameraPosition() {
    if (_controller.isCompleted && _currentLocation != null) {
      _controller.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
              zoom: 17.0,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _updateCameraPosition();
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 17.0,
      ),
    myLocationEnabled: true,
  myLocationButtonEnabled: true,
  zoomGesturesEnabled: true, 
  scrollGesturesEnabled: true, 
  zoomControlsEnabled: false, 
    );
  }
}