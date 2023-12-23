import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/intro/custom_true.dart';

import '../screens/client/car_form.dart';
import '../screens/client/registration_form_client.dart';
import '../screens/vendor/Registration_form.dart';
import '../screens/vendor/orders.dart';

class RegesterController extends GetxController {
  var isLoading = false.obs;

  Future<void> postClientRegistration({
    required String name,
    required String email,
    required String birthDate,
    required String carTypeId,
    required String latitude,
    required String longitude,
  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/client/register");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    isLoading(true);
    try {
      final response = await http.post(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {
          'name': name,
          'email': email,
          'birth_date': birthDate,
          'cars[]': carTypeId,
          'lat': latitude,
          'long': longitude,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        var data = jsonDecode(response.body);
        print(response.body);
      } else {
        // Handle error
        print('Failed to register client');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while registering client: $e');
    } finally {
      isLoading(false);
    }
  }

//client
  var carTypes = <Map<String, dynamic>>[].obs;

//vendor
    var selectedCarTypes = <String>[].obs;


  Future<void> fetchCarTypes() async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/lists/cars");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    isLoading(true);
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
        carTypes.value = List<Map<String, dynamic>>.from(data);
      } else {
        // Handle error
        print('Failed to fetch car types');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while fetching car types: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> navigateBasedClint(BuildContext context) async {
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
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Response body: ${response.body}');

        String completeRegistration = jsonResponse['complete_registration'];

        if (completeRegistration == "1") {
          // If number is 1, navigate to FirstScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarForm()),
          );
        } else if (completeRegistration == "0") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RegistrationFormClinet()),
          );
        }
      } else {
        // Handle non-200 responses
        print('Request failed with status: ${response.body}.');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error occurred: $e');
    }
  }

  Future<void> navigateBasedVendor(BuildContext context) async {
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
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Response body: ${response.body}');

        String completeRegistration = jsonResponse['complete_registration'];
        String isVerified = jsonResponse['is_verified'];

          if (completeRegistration == "0") {
            // If number is 1, navigate to FirstScreen
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegistrationForm()),
            
            );
          } 
        } else {
          // Handle non-200 responses
          print('Request failed with status: ${response.body}.');
      }
    } catch (e) {
      // Handle any exceptions
      print('Error occurred: $e');
    }
  }

  // Future<void> postVendorRegistration({
  //   required String name,
  //   required String email,
  //   required List<String> carTypeIds,
  //   required String latitude,
  //   required String longitude,
  //   required List<XFile> images,
  // }) async {
  //   final Uri apiEndpoint =
  //       Uri.parse("https://slfsparepart.com/api/vendor/register");
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? authToken = prefs.getString('auth_token');
  //   isLoading(true);

  //   List<String> base64Images = [];
  //   for (XFile image in images) {
  //     final bytes = await image.readAsBytes();
  //     String imgBase64Str = base64Encode(bytes);
  //     base64Images.add(imgBase64Str);
  //   }

  //   try {
  //     final response = await http.post(
  //       apiEndpoint,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $authToken',
  //       },
  //       body: {
  //         'name': name,
  //         'email': email,
  //         'cars[]': carTypeIds,
  //         'lat': latitude,
  //         'long': longitude,
  //         'files': base64Images,
  //       },
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Handle success
  //       var data = jsonDecode(response.body);
  //       print(data);

  //       print(response.body);
  //     } else {
  //       // Handle error
  //       print('Failed to register client');
  //       print(response.body);
  //     }
  //   } catch (e) {
  //     // Handle any exceptions here
  //     print('Error occurred while registering client: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> postVendorRegistration({
    required String name,
    required String email,
    required List<String> carTypeIds,
    required String latitude,
    required String longitude,
    required List<XFile> images,
  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/vendor/register");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    isLoading(true);

    List<String> base64Images = [];
    for (XFile image in images) {
      final bytes = await image.readAsBytes();
      String imgBase64Str = base64Encode(bytes);
      base64Images.add(imgBase64Str);
    }

    // Construct the request body as a Map
    Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'cars': carTypeIds, // Assuming the API expects an array for car types
      'lat': latitude,
      'long': longitude,
      'files': base64Images, // Assuming the API expects an array for files
    };

    try {
      final response = await http.post(
        apiEndpoint,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(requestBody), // Encode the Map as a JSON string
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        var data = jsonDecode(response.body);
        print(data);
      } else {
        // Handle error
        print('Failed to register client');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while registering client: $e');
    } finally {
      isLoading(false);
    }
  }

}
