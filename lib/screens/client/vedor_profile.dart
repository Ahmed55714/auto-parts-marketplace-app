import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:work2/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../vendor/Bottom_nav.dart';
import '../vendor/chat/screens/mobile_chat_screen.dart';

class VenforProfile extends StatefulWidget {
  final int userId;
  const VenforProfile({super.key, required this.userId});

  @override
  State<VenforProfile> createState() => _VenforProfileState();
}

class _VenforProfileState extends State<VenforProfile> {
  late Future<VendorProfile> vendorProfileFuture;

  @override
  void initState() {
    super.initState();
    vendorProfileFuture = fetchVendorProfile(widget.userId);
  }

  Future<VendorProfile> fetchVendorProfile(int userId) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/vendor/$userId/profile");

    try {
      final prefs = await SharedPreferences.getInstance();
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

        return VendorProfile.fromJson(data);
      } else {
        throw Exception(
            'Failed to load vendor profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load vendor profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
       Scaffold(
        body: SafeArea(
          child: FutureBuilder<VendorProfile>(
            future: vendorProfileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("${S.of(context).AreCancel36}"));
              } else if (snapshot.hasData) {
                return buildProfile(snapshot.data!);
              } else {
                return Center(child: Text(S.of(context).error2));
              }
            },
          ),
        ),
      
    );
  }

  @override
  Widget buildProfile(VendorProfile profile) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButtonDeep(),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).Profile,
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
                        child: ClipOval(
                          child: Image.network(
                            profile.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          S.of(context).AreCancel37,
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
                    child: Text(
                      profile.summary ?? S.of(context).AreCancel38,
                      style: TextStyle(
                        color: greyColor,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          S.of(context).Location,
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
                    height: 200, // Set a height for the map container
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(profile.lat, profile.long),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('vendorLocation'),
                            position: LatLng(profile.lat, profile.long),
                          ),
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          S.of(context).AreCancel39,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  HorizontalReviewList(
                    ratings: profile.ratings,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: S.of(context).AreCancel40,
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => MobileChatScreen(
                                    userId: widget.userId,
                                    name: profile.name,
                                    pic: profile.imageUrl,
                                  )),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
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
  final List<Ratings> ratings;

  HorizontalReviewList({required this.ratings});

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              'No reviews available',
              style: TextStyle(
                fontSize: 16.0,
                color: greyColor,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ratings.length,
        itemBuilder: (BuildContext context, int index) {
          return ReviewCard(rating: ratings[index]);
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Ratings rating;

  ReviewCard({required this.rating});

  @override
  Widget build(BuildContext context) {
    int starCount = int.tryParse(rating.stars) ?? 0;
    bool isReviewEmpty = rating.comment.isEmpty && starCount == 0;
    if (isReviewEmpty) {
      return Container(
        width: 350,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          S.of(context).AreCancel41,
          style: TextStyle(
            fontSize: 16.0,
            color: greyColor,
            fontFamily: 'Roboto',
          ),
        ),
      );
    } else {
      return Container(
        width: 350,
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              rating.stars,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < starCount ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                  size: 25,
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                rating.comment,
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class VendorProfile {
  final int id;
  final String name;
  final String? summary;
  final double lat;
  final double long;
  final String imageUrl;
  final double avgRating;
  final List<Ratings> ratings;

  VendorProfile({
    required this.id,
    required this.name,
    this.summary,
    required this.lat,
    required this.long,
    required this.imageUrl,
    required this.avgRating,
    required this.ratings,
  });

  factory VendorProfile.fromJson(Map<String, dynamic> json) {
    var ratingsList = json['ratings'] != null && json['ratings'] is List
        ? List<Ratings>.from((json['ratings'] as List).map((ratingJson) =>
            Ratings.fromJson(ratingJson as Map<String, dynamic>)))
        : <Ratings>[];

    return VendorProfile(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Default Name',
      summary: json['summary'] as String?,
      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString()) ?? 0.0
          : 0.0,
      long: json['long'] != null
          ? double.tryParse(json['long'].toString()) ?? 0.0
          : 0.0,
      imageUrl: json['image_url'] as String? ??
          'https://example.com/default_image.png',
      avgRating: json['avg_rating'] != null
          ? double.tryParse(json['avg_rating'].toString()) ?? 0.0
          : 0.0,
      ratings: ratingsList,
    );
  }
}

class Ratings {
  final String stars;
  final String comment;

  Ratings({required this.stars, required this.comment});

  factory Ratings.fromJson(Map<String, dynamic> json) {
    // Handle 'stars' as int or String
    String starsString;
    if (json['stars'] is int) {
      starsString = (json['stars'] as int).toString();
    } else {
      starsString = json['stars'] as String? ?? '0';
    }

    return Ratings(
      stars: starsString,
      comment: json['comment'] as String? ?? 'No comment',
    );
  }
}
