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
        Get.snackbar('Error', 'Verification Failed please check your internet');
      },
      codeSent: (String verificationId, int? resendToken) {
        isLoading(false);
        
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
       
      

      

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Here we assume the token is returned in the response body
          var data = jsonDecode(response.body);
          var token = data['token'];
          await saveToken(token);
         
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

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  
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
   ;
      } else {
        // Handle error
  
      }
    } catch (e) {
      // Handle any exceptions
    
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

void switchLanguage() {
  Locale currentLocale = Get.locale!;
  if (currentLocale.languageCode == 'en') {
    Get.updateLocale(Locale('ar', 'AR'));
  } else {
    Get.updateLocale(Locale('en', 'US'));
  }
}
}
