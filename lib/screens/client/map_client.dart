import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../../getx/regestration.dart';
import '../../widgets/custom_button.dart';
import '../vendor/profile.dart';

class ClientMap extends StatefulWidget {
  const ClientMap({super.key});

  @override
  State<ClientMap> createState() => _ClientMapState();
}

class _ClientMapState extends State<ClientMap> {
  final RegesterController regesterController = Get.find<RegesterController>();
  bool hasVisitedRegistrationScreen = false;

  Future<List<PersonLocation>> fetchLocations() async {
    final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/map");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    if (authToken == null) {
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
        List<dynamic> data = jsonDecode(response.body);
        return data.map<PersonLocation>((locationJson) {
          return PersonLocation.fromJson(locationJson);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<List<PersonLocation>>(
              future: fetchLocations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error occurred'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return CustomGoogleMapp();
                } else {
                  return CustomGoogleMap(locations: snapshot.data!);
                }
              },
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CustomButton(
                  text: S.of(context).Map,
                  onPressed: () {
                    regesterController.navigateBasedClint(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomGoogleMap extends StatefulWidget {
  final List<PersonLocation> locations;

  const CustomGoogleMap({Key? key, required this.locations}) : super(key: key);

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location _location = Location();
  LocationData? _currentLocation;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _setMarkers(widget.locations);
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

  void _setMarkers(List<PersonLocation> locations) {
    final Set<Marker> _markers = {};
    for (var location in locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location.id.toString()),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: location.name),
        ),
      );
    }

    setState(() {
      markers = _markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        _updateCameraPosition();
      },
      initialCameraPosition: CameraPosition(
        target: _currentLocation != null
            ? LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!)
            : LatLng(37.33500926, -122.03272188), // Default position
        zoom: 12.0,
      ),
      markers: markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
    );
  }
}

// Placeholder for CustomSearchBar


class PersonLocation {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String imageUrl;

  PersonLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });
  factory PersonLocation.fromJson(Map<String, dynamic> json) {
    return PersonLocation(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      latitude: json['lat'] != null
          ? double.tryParse(json['lat'].toString()) ?? 0.0
          : 0.0,
      longitude: json['long'] != null
          ? double.tryParse(json['long'].toString()) ?? 0.0
          : 0.0,
      imageUrl: json['image_url'] as String? ??
          '', // Provide a default value in case of null
    );
  }
}
