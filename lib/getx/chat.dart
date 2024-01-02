// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatController extends GetxController {
//   var messages = <Message>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMessages();
//   }

//   Future<void> fetchMessages() async {
//     final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/chat/2/show");
//     final SharedPreferences prefs = await SharedPreferences.getInstance(); // Corrected here
//     final String? authToken = prefs.getString('auth_token');
    
//     if (authToken == null) {
//       throw Exception('Auth token is null');
//     }

//     final response = await http.get(
//       apiEndpoint,
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $authToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       List<Message> fetchedMessages = (data['messages'] as List)
//           .map((message) => Message.fromJson(message))
//           .toList();
//       messages.assignAll(fetchedMessages); // Using assignAll to update the list
//     } else {
//       throw Exception('Failed to load messages: ${response.statusCode}');
//     }
//   }
// }

// class Message {
//   final int id;
//   final String content;
//   final bool isSeen;
//   final bool iSentThis;

//   Message({
//     required this.id,
//     required this.content,
//     required this.isSeen,
//     required this.iSentThis,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['id'],
//       content: json['content'],
//       isSeen: json['is_seen'] == "1",
//       iSentThis: json['i_sent_this'] == true,
//     );
//   }
// }


import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  var messages = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/chat/2/show");
    final SharedPreferences prefs = await SharedPreferences.getInstance(); // Fixed here
    final String? authToken = prefs.getString('auth_token');
    
    if (authToken == null) {
      throw Exception('Auth token is null');
    }

    final response = await http.get(
      apiEndpoint,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Message> fetchedMessages = (data['messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList();
      messages.assignAll(fetchedMessages); // It's better to use assignAll here
    } else {
      throw Exception('Failed to load messages: ${response.statusCode}');
    }
  }
}


class Message {
  final int id;
  final String content;
  final bool isSeen;
  final bool iSentThis;

  Message({
    required this.id,
    required this.content,
    required this.isSeen,
    required this.iSentThis,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isSeen: json['is_seen'] == "1",
      iSentThis: json['i_sent_this'] == true,
    );
  }
}
