import 'package:flutter/material.dart';

import 'package:work2/widgets/custom_button.dart';

import '../../constants/colors.dart';
import '../vendor/Bottom_nav.dart';

class VenforProfile extends StatelessWidget {
  const VenforProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BackButtonDeep(),
                      ],
                    ),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.deepPurple, width: 2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Ahmed said',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Summery',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    child: const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu',
                      style: TextStyle(
                        color: greyColor,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    child: const Text(
                      'map',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  HorizontalReviewList(),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: 'contact',
                      onPressed: () {
                        showChatBottomSheet(context);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showChatBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 1.0,
          builder: (_, controller) => ChatBottomSheet(),
        );
      },
    );
  }
}

class ChatBottomSheet extends StatefulWidget {
  @override
  _ChatBottomSheetState createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: deepPurple,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color:
                  deepPurple, // Here we set the color for the top rounded part
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
          ),
          // Vendor profile area
          Container(
            color: deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Ahmed Khaled',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),

          // Summary area

          // Chat messages list
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: 5, // Placeholder for message count
                itemBuilder: (BuildContext context, int index) {
                  // Alternating chat bubble alignment
                  bool isMe =
                      index % 2 == 0; // Placeholder for user message check
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: ChatBubble(
                      message:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                      timestamp: '08:00 PM',
                      isMe: isMe,
                    ),
                  );
                },
              ),
            ),
          ),

          // Message input row
          SafeArea(
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write your message...',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple, // Deep purple color
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          // TODO: Implement send message functionality
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String timestamp;
  final bool isMe;

  ChatBubble({
    required this.message,
    required this.timestamp,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) ...[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              // Placeholder for other person's avatar
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
        ],
        Container(
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: isMe ? Colors.deepPurple : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft:
                  isMe ? const Radius.circular(15) : const Radius.circular(0),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                timestamp,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CircleAvatar(
              // Placeholder for current user's avatar
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
        ],
      ],
    );
  }
}

class HorizontalReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the height to accommodate the ReviewCard's size
      height: 180,

      child: ListView.builder(
        // Set scroll direction to horizontal
        scrollDirection: Axis.horizontal,
        itemCount: 10, // Number of review cards in the list
        itemBuilder: (BuildContext context, int index) {
          return ReviewCard();
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350, // Set a fixed width for each card
      padding: const EdgeInsets.all(16.0),
      margin:
          const EdgeInsets.symmetric(horizontal: 8.0), // Margin between cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '4.0',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.star, color: Colors.orange, size: 20),
              Icon(Icons.star, color: Colors.orange, size: 20),
              Icon(Icons.star, color: Colors.orange, size: 20),
              Icon(Icons.star, color: Colors.orange, size: 20),
              Icon(Icons.star_border, color: Colors.orange, size: 20),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
          Text(
            'Ali',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              fontFamily: 'Roboto',
            ),
          ),
          Text(
            'Dec 2023',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }
}
