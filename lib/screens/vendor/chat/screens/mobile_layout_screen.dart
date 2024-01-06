import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:work2/constants/colors.dart';

import '../../Bottom_nav.dart';
import 'package:http/http.dart' as http;

import 'mobile_chat_screen.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  late Future<List<Contact>> contactsFuture;
    Timer? _timer;


  @override
  void initState() {
    super.initState();
    contactsFuture = fetchContacts();
   _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        contactsFuture = fetchContacts();
      });
    });
  }
    @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  Future<List<Contact>> fetchContacts() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? authToken = prefs.getString('auth_token');

  final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/chat/inbox");
  final response = await http.get(
    apiEndpoint,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
  );

  if (response.statusCode == 200) {
  
    List<dynamic> contactsJson = jsonDecode(response.body);
    return contactsJson.map((json) => Contact.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load contacts: ${response.body}');
  }
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButtonDeep(),
                    ],
                  ),
                ),
                Text(
                  'Chat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
               ContactsList(
                  contactsFuture: contactsFuture,
               ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactsList extends StatelessWidget {
    final Future<List<Contact>> contactsFuture;

  const ContactsList({
    Key? key,
    required this.contactsFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: contactsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Contact contact = snapshot.data![index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                         Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (context) => MobileChatScreen(
        userId: contact.user.id,
        name: contact.user.name,
        pic: contact.user.imageUrl,
      )));
        
      
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact.user.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            contact.lastMessage.content,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            contact.user.imageUrl,
                          ),
                          radius: 30,
                        ),
                        
                        trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                if (contact.unreadMessages > 0)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                         Text(
                  contact.lastMessage.time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
             
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          contact.unreadMessages.toString(),
                          
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    
                    ],
                  ),
              
               
              ],
            ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey, indent: 85),
                ],
              );
            },
          );
        } else {
          return Center(child: Text("No contacts available"));
        }
      },
    );
  }
      
  
  }

class Contact {
  final int id;
  final User user;
  final Message lastMessage;
  final int unreadMessages;

  Contact({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.unreadMessages,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      user: User.fromJson(json['user']),
      lastMessage: Message.fromJson(json['last_message']),
      unreadMessages: json['unread_messages'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String imageUrl;
  final String avgRating;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.avgRating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String? ?? 'default_image_url', // Provide a default URL if null
      avgRating: json['avg_rating'] as String? ?? 'N/A', // Provide a default value if null
    );
  }
}

class Message {
  final int id;
  final String content;
  final String isSeen;
  final String time;
  final bool iSentThis;

  Message({
    required this.id,
    required this.content,
    required this.isSeen,
    required this.time,
    required this.iSentThis,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      content: json['content'] as String,
      isSeen: json['is_seen'] as String? ?? '0', // Provide a default value if null
      time: json['time'] as String? ?? 'Unknown time', // Provide a default value if null
      iSentThis: json['i_sent_this'] == true,
    );
  }
}
