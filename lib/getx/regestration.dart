import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../screens/client/car_form.dart';
import '../screens/client/carform2.dart';
import '../screens/client/registration_form_client.dart';
import '../screens/vendor/Registration_form.dart';

class RegesterController extends GetxController {
  var isLoading = false.obs;
  var message = ''.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setMessage(String value) {
    message.value = value;
  }

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
        print(data);
        print(response.body);
        print('Response body: ${response.request}');
        setMessage('Success');
      } else {
        // Handle error
        setMessage('Failed to register client');
        print('Failed to register client');
        print(response.body);
      }
    } catch (e) {
      print('Error occurred while registering client: $e');
      if (e is SocketException) {
        setMessage('Please check your internet connection');
      } else {
        setMessage('Error occurred while registering client: $e');
      }
    } finally {
      setLoading(false);
    }
  }

//vendor
  //var selectedCarTypes = <String>[].obs;
//client
  var carTypes = <Map<String, dynamic>>[].obs;

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

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        // Change to int since the value is an integer
        int completeRegistration = jsonResponse['complete_registration'];

        if (completeRegistration == 1) {
          // If number is 1, navigate to FirstScreen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CarForm()),
          );
          print('Response body: ${response.body}');
          print(authToken);
        } else if (completeRegistration == 0) {
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

  Future<void> navigateBasedClint2(BuildContext context) async {
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

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        // Change to int since the value is an integer
        int completeRegistration = jsonResponse['complete_registration'];

        if (completeRegistration == 1) {
          // If number is 1, navigate to FirstScreen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  const CarForm2()),
          );
          print('Response body: ${response.body}');
        } else if (completeRegistration == 0) {
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

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print('Response body: ${response.body}');

        String completeRegistration = jsonResponse['complete_registration'];
        String isVerified = jsonResponse['is_verified'];

        if (completeRegistration == "0") {
          // If number is 1, navigate to FirstScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrationForm()),
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

    try {
      final request = http.MultipartRequest('POST', apiEndpoint)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $authToken'
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['lat'] = latitude
        ..fields['long'] = longitude;

      // Add car type IDs to the request as individual fields
      for (var i = 0; i < carTypeIds.length; i++) {
        request.fields['cars[$i]'] = carTypeIds[i];
      }

      // Add images to the request as multipart files
      for (var image in images) {
        final mimeTypeData =
            lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
        var multipartFile = await http.MultipartFile.fromPath(
          'files[]', // This is the field name that the server expects for files
          image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        var jsonResponse = json.decode(response.body);
        print('Response body: ${response.body}');
        print(jsonResponse);
      } else {
        // Handle error
        print('Failed to register client');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while registering client: $e');
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
