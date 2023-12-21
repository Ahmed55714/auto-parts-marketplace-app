import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/intro/sign_up.dart';
import '../screens/intro/verification.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    isLoading(true);
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await postUserData(_auth.currentUser!);
      },
      verificationFailed: (FirebaseAuthException e) {
        isLoading(false);
        Get.snackbar('Error', 'Verification Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        isLoading(false);
        // Navigate to OTP screen with verificationId
        Get.to(() => VerificationScreen(
            verificationId: verificationId, phoneNumber: phoneNumber));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOtp(
      String verificationId, String smsCode, String phoneNumber) async {
    isLoading(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
      await postUserData(_auth.currentUser!);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  Future<void> postUserData(User user) async {
    if (user != null) {
      final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/login");
      isLoading(true);
      try {
        final response = await http.post(
          apiEndpoint,
          headers: {
            //'Content-Type': 'application/json',
            //"Content-Type": "application/x-www-form-urlencoded",
            'Accept': 'application/json',
          },
          body: {
            'uid': user.uid,
            'phone': user.phoneNumber,
          },
        );
        print(user.uid);
        print(user.phoneNumber);

        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Here we assume the token is returned in the response body
          var data = jsonDecode(response.body);
          var token = data['token'];
          await saveToken(token);
          print(token);
          Get.snackbar(
            'Success',
            'Verify successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Navigate to the sign-up page
          Get.offAll(() => SignUp());
        } else {
          Get.snackbar('Error', 'Failed to Verify');
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred while posting data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(e.toString());
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token saved successfully');
  }

  Future<String?> getToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
    
  }

  Future<void> postType(String type) async {
    final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/signup");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    try {
      final response = await http.post(
        apiEndpoint,
        headers: {
          //'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {
          'type': type,
        },
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print('Type posted successfully');
        print(response.body);
      } else {
        // Handle error
        print('Failed to post type');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions
      print('Error posting type: $e');
    }
  }

  // Save the user type
  Future<void> saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_type', userType);
  }

  // Get the user type
  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_type');
  }

// get list of car types

  // var carTypes = <String>[].obs;

  // @override
  // void onInit() {
  //   fetchCarTypes();
  //   super.onInit();
  // }

  // void fetchCarTypes() async {
  //   isLoading(true);
  //   var url = Uri.parse('https://slfsparepart.com/api/lists/cars');
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? authToken = prefs.getString('auth_token');
  //   try {
  //     var response = await http.get(
  //       url,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $authToken',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       List<dynamic> carTypesJson = json.decode(response.body);

  //       carTypes.value = List<String>.from(carTypesJson);
  //     } else {

  //     }
  //   } catch (e) {

  //   } finally {
  //     isLoading(false);
  //   }
  // }
}
