import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../getx/chat.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';


// class ChatList extends StatelessWidget {
//   final ChatController chatController = Get.put(ChatController());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (chatController.messages.isEmpty) {
//         return Center(child: CircularProgressIndicator()); // Show a loading indicator while messages are empty
//       }

//       return ListView.builder(
//         itemCount: chatController.messages.length,
//         itemBuilder: (context, index) {
//           var message = chatController.messages[index];
//           if (message.iSentThis) {
//             return MyMessageCard(
//               message: message.content,
//             );
//           } else {
//             return SenderMessageCard(
//               message: message.content,
//             );
//           }
//         },
//       );
//     });
//   }
// }

// class ChatList extends StatelessWidget {
//   final ChatController chatController = Get.put(ChatController());

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Message>>(
//       stream: chatController.messagesStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No messages.'));
//         }

//         List<Message> messages = snapshot.data!;
//         return ListView.builder(
//           itemCount: messages.length,
//           itemBuilder: (context, index) {
//             var message = messages[index];
//             if (message.iSentThis) {
//               return MyMessageCard(message: message.content);
//             } else {
//               return SenderMessageCard(message: message.content);
//             }
//           },
//         );
//       },
//     );
//   }
// }





import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  var messages = <Message>[].obs;
  final StreamController<List<Message>> _messagesStreamController = StreamController.broadcast();

  @override
  void onInit() {
    super.onInit();
    fetchMessagesPeriodically();
  }

  @override
  void onClose() {
    _messagesStreamController.close();
    super.onClose();
  }

  // Method to return the stream
  Stream<List<Message>> streamMessages() => _messagesStreamController.stream;

  void fetchMessagesPeriodically() {
    Timer.periodic(Duration(seconds: 30), (_) async {
      await fetchMessages();
    });
  }

  Future<void> fetchMessages() async {
    final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/chat/2/show");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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
      _messagesStreamController.add(fetchedMessages); // Update the stream with new messages
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
