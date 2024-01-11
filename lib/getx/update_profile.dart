import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileController extends GetxController {
  var isLoading = false.obs;
  var profileImageUrl = RxString(""); // Correctly declared as an observable

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? image,
  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/user/update");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    isLoading(true);
    try {
      final request = http.MultipartRequest('POST', apiEndpoint)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $authToken'
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['phone'] = phone;

      if (image != null) {
        final mimeTypeData =
            lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
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
      } else {
        // Handle error
      }
    } on SocketException {
      Get.snackbar(
        'No Internet Connection',
        'Make sure you are connected to the internet and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on HttpException {
      Get.snackbar(
        'Server Error',
        'Could not complete your request. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on FormatException {
      Get.snackbar(
        'Bad Response Format',
        'Invalid server response. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> createAdress({
    required String name,
    required String street,
    required String building,
    required String floor,
    required String apartment,
    required String lat,
    required String long,
  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/user/addresses/create");
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
          'street': street,
          'building': building,
          'floor': floor,
          'apartment': apartment,
          'lat': lat,
          'long': long,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        var data = jsonDecode(response.body);
        print(data);
        print(authToken);
      } else {
        // Handle error
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteAdress({
    required String name,
    required String street,
    required int building,
    required int floor,
    required int apartment,
    required String lat,
    required String long,
  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/user/addresses/create");
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
          'street': street,
          'building': building,
          'floor': floor,
          'apartment': apartment,
          'lat': lat,
          'long': long,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        var data = jsonDecode(response.body);
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle any exceptions here
    } finally {
      isLoading(false);
    }
  }
}
