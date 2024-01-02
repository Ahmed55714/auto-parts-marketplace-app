import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:work2/constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../Bottom_nav.dart';
import '../info.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends StatefulWidget {
  MobileChatScreen({Key? key}) : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  String? userName;
  String? userImageUrl;

  Future<void> postMessage({
    required int userId,
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
          'user_id': userId.toString(),
          'content': content,
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        var data = jsonDecode(response.body);
        print('Message sent: $data');
        print(response.body);
        // Do something with the response data
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

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    // Replace with the actual user ID or fetch it from saved preferences
    final int userId = 2;
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/user/$userId");

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('auth_token');
      final response = await http.get(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName =
              data['name']; // Assuming 'name' is the key for the user's name
          userImageUrl = data['image_url']; // Assuming 'image_url' is the key
        });
      } else {
        print('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching user profile: $e');
    }
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
                      userImageUrl ?? 'https://picsum.photos/250?image=9',
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? 'Loading...',
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
              child: ChatList(
                userName: userName,
                userImageUrl: userImageUrl,
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
                            // Retrieve the user ID from user profile or similar
                            int userId =
                                2; // Example user ID, replace with actual user ID
                            postMessage(
                                    userId: userId,
                                    content: _messageController.text)
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
    _messageController.dispose();
    super.dispose();
  }
}
