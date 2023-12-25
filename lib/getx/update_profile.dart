import 'dart:convert';


import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class UpdateProfileController extends GetxController {
  var isLoading = false.obs;
  var profileImageUrl = RxString(""); // Correctly declared as an observable


  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,

  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/user/update");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    print('Auth Token: $authToken');
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
          'phone': phone,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success      
        print(response.body);
        print('Response body: ${response.request}');
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
    
        print('Response body: ${response.request}');
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
        print(data);
    
        print('Response body: ${response.request}');
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
  // Future<void> getAddress() async {
  //   final Uri apiEndpoint =
  //       Uri.parse("https://slfsparepart.com/api/user/addresses");
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? authToken = prefs.getString('auth_token');
  //   isLoading(true);
  //   try {
  //     final response = await http.post(
  //       apiEndpoint,
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $authToken',
  //       },
       
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Handle success
  //      List<dynamic> data = jsonDecode(response.body);
  //     List<Address> addresses = data.map((addressData) => Address.fromJson(addressData)).toList();
  //     return addresses;
    
  //       print('Response body: ${response.request}');
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
// Future<List<Address>> getAddress() async {
//     final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/user/addresses");
//     final prefs = await SharedPreferences.getInstance();
//     final String? authToken = prefs.getString('auth_token');

//     isLoading(true);
//     try {
//       final response = await http.get(
//         apiEndpoint,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $authToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> jsonData = jsonDecode(response.body);
//         List<Address> addresses = jsonData.map((json) => Address.fromJson(json)).toList();
//         return addresses;
//       } else {
//         // Handle error
//         print('Failed to get addresses: ${response.body}');
//         return []; // Return an empty list in case of error
//       }
//     } catch (e) {
//       // Handle any exceptions here
//       print('Error occurred while fetching addresses: $e');
//       return []; // Return an empty list in case of error
//     } finally {
//       isLoading(false);
//     }
//   }
  








  //   Future<void> profilePic() async {
  //   var url = Uri.parse('https://slfsparepart.com/api/user');
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

  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //      var data = json.decode(response.body);
  //      String  profileImageUrl= data['image_url'] ?? ""; // Update the observable variable
  //     } else {
  //       // Handle non-200 responses
  //       print('Request failed with status: ${response.body}.');
  //     }
  //   } catch (e) {
  //     // Handle any exceptions
  //     print('Error occurred: $e');
  //   }
  // }


  // class Address {
  // final int id;
  // final String name;
  // final String street;
  // final String building;
  // final String floor;
  // final String apartment;
  // final String lat;
  // final String long;

  // Address({
  //   required this.id,
  //   required this.name,
  //   required this.street,
  //   required this.building,
  //   required this.floor,
  //   required this.apartment,
  //   required this.lat,
  //   required this.long,
  // });

  // factory Address.fromJson(Map<String, dynamic> json) {
  //   return Address(
  //     id: json['id'],
  //     name: json['name'],
  //     street: json['street'],
  //     building: json['building'],
  //     floor: json['floor'],
  //     apartment: json['apartment'],
  //     lat: json['lat'],
  //     long: json['long'],
  //   );
  // }
//}