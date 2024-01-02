// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Bottom_nav.dart';
import '../widgets/my_message_card.dart';
import '../widgets/sender_message_card.dart';

class MobileChatScreen extends StatefulWidget {
  final int userId;
  final String? name;
  final String? pic;
  MobileChatScreen({
    Key? key,
    required this.userId,
    this.name,
    this.pic,
  }) : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  var messages = <Message>[].obs;
  Timer? _timer;

  Future<void> postMessage({
    required String content,
  }) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/chat/messages/create");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.post(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {
          'user_id': widget.userId.toString(),
          'content': content,
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        var data = jsonDecode(response.body);
        print('Message sent: $data');
        print(response.body);
        await fetchMessages(widget.userId);
      } else {
        // Handle error
        print('Failed to send message: ${response.statusCode}');
        print('Error body: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while sending message: $e');
    } finally {
      // Stop loading indication
      // isLoading(false);
    }
  }

  Future<void> fetchMessages(int userId) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/chat/${userId}/show");
    final SharedPreferences prefs =
        await SharedPreferences.getInstance(); // Fixed here
    final String? authToken = prefs.getString('auth_token');

    final response = await http.get(
      apiEndpoint,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    print('API Response for user $userId: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Message> fetchedMessages = (data['messages'] as List)
          .map((message) => Message.fromJson(message))
          .toList();
      messages.assignAll(fetchedMessages);
      print(response.body);
    } else {
      throw Exception('Failed to load messages: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages(widget.userId);
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      fetchMessages(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  BackButtonDeep(),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.pic ?? 'https://picsum.photos/250?image=9',
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name ?? 'Loading...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Text(
                      //   'Active Now',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.green,
                      //   ),
                      // ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (messages.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      if (message.iSentThis) {
                        return MyMessageCard(
                          message: message.content,
                          isSeen: message.isSeen,
                        );
                      } else {
                        return SenderMessageCard(
                          message: message.content,
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Write your message",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            postMessage(content: _messageController.text)
                                .then((_) {
                              // Clear the message input field after sending the message
                              setState(() {
                                _messageController.clear();
                              });
                              // Optionally, handle any UI updates here
                            });
                          }
                        },
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    super.dispose();
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
    required this.isSeen, // This is a boolean now
    required this.iSentThis,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isSeen: json['is_seen'] == "1", // Parse the string to a boolean
      iSentThis: json['i_sent_this'] == true,
    );
  }
}
