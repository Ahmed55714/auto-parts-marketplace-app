import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersController extends GetxController {
  var isLoading = false.obs;

  var PieceTypes = <Map<String, dynamic>>[].obs;

  Future<void> fetchPieceTypes() async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/lists/piece/types");
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
        PieceTypes.value = List<Map<String, dynamic>>.from(data);
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle any exceptions here
    } finally {
      isLoading(false);
    }
  }

  var PieceDeltals = <Map<String, dynamic>>[].obs;

  Future<void> fetchPieceDeltals() async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/lists/piece/details");
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
        PieceDeltals.value = List<Map<String, dynamic>>.from(data);
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle any exceptions here
    } finally {
      isLoading(false);
    }
  }






  Future<void> carFormClient({
    required String carPiece,
    required List<String> carTypeIds,
    required String carModelIds,
    required String chassisNumber,
    required List<String> pieceType,
    required List<String> pieceDetail,
    // required List<XFile> images,
    // required String birthDate,
    required String latitude,
    required String longitude,
    required String for_government,
  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/client/orders/create");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    isLoading(true);

    try {
      final request = http.MultipartRequest('POST', apiEndpoint)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $authToken'
        ..fields['car_piece'] = carPiece
        ..fields['car_model'] = carModelIds
        ..fields['chassis_number'] = chassisNumber
        //..fields['date'] = birthDate
        ..fields['lat'] = latitude
        ..fields['long'] = longitude
        ..fields['for_government'] = for_government
        ..fields['car_id'] = carTypeIds.join(',')
        ..fields['piece_type_id'] = pieceType.join(',')
        ..fields['piece_detail_id'] = pieceDetail.join(',');

      // Add images to the request as multipart files
      // for (var image in images) {
      //   final mimeTypeData =
      //       lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      //   var multipartFile = await http.MultipartFile.fromPath(
      //     'files[]',
      //     image.path,
      //     contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      //   );
      //   request.files.add(multipartFile);
      // }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        var jsonResponse = json.decode(response.body);
        print('Response body: ${response.body}');
      } else {
        // Handle error
        print('Response body: ${response.body}');
      }
    } catch (e) {
      Get.snackbar(
        'Upload Error',
        'Failed to upload: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> OfferForm({
    required String orderId,
    required String Piece,
    required String country,
    required String yearModel,
    required String chassisNumber,
    required String condition,
    required String price,
    required String notes,
    required List<XFile> images,
  }) async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/vendor/orders/$orderId/offers/create");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    isLoading(true);

    try {
      final request = http.MultipartRequest('POST', apiEndpoint)
        ..headers['Accept'] = 'application/json'
        ..headers['Authorization'] = 'Bearer $authToken'
        ..fields['piece'] = Piece
        ..fields['country'] = country
        ..fields['year_model'] = yearModel
        ..fields['condition'] = condition
        ..fields['price'] = price
        ..fields['notes'] = notes;

      // Add images to the request as multipart files
      for (var image in images) {
        final mimeTypeData =
            lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
        var multipartFile = await http.MultipartFile.fromPath(
          'files[]',
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
      } else {
        

        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Offer Error'),
              content: Text('This order cannot receive offers at the moment.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      Get.snackbar(
        'Network Error',
        'Could not connect to the server. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
