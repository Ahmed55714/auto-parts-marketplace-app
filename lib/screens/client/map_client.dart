import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return CustomGoogleMapp();
                } else {
                  return CustomGoogleMap(locations: snapshot.data!);
                }
              },
            ),
            // const Column(
            //   children: [
            //     CustomSearchBar(),
            //     Spacer(),
            //   ],
            // ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CustomButton(
                text: 'Order Now',
                onPressed: () => regesterController.navigateBasedClint(context),
              ),
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
  final LatLng _initialPosition = const LatLng(37.33500926, -122.03272188);
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers(widget.locations);
  }

  void _setMarkers(List<PersonLocation> locations) {
    final Set<Marker> _markers = {};
    for (var location in locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(location.id.toString()),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(title: location.name),

          // Optional: if you want to use custom images as marker icons
          // icon: BitmapDescriptor.fromNetwork(location.imageUrl),
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
      },
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
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
