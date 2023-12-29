import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/client/payment.dart';

import '../../constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../vendor/Bottom_nav.dart';
import 'orders_clint.dart';
import 'vedor_profile.dart';
import 'package:http/http.dart' as http;

class OfferClient extends StatefulWidget {
  final List<int> orderIds;

  const OfferClient({Key? key, required this.orderIds}) : super(key: key);

  @override
  _OfferClientState createState() => _OfferClientState();
}

class _OfferClientState extends State<OfferClient> {
  var offers = <int, List<Offer>>{}.obs;

  @override
  void initState() {
    super.initState();
    fetchAllOffers();
  }

  Future<void> fetchAllOffers() async {
    for (var orderId in widget.orderIds) {
      await fetchOffers(orderId);
    }
  }

  Future<void> fetchOffers(int orderId) async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/client/orders/${orderId}/offers");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.get(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['offers'] is List) {
          List<dynamic> jsonList = jsonResponse['offers'];
          var fetchedOffers =
              jsonList.map((json) => Offer.fromJson(json)).toList();
          if (fetchedOffers.isNotEmpty) {
            offers[orderId] = fetchedOffers; 
            print(response.body);
          }
        } else {
          print('Offers key not found or is not a list');
        }
      } else {
        print('Failed to fetch Offers for order $orderId: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while fetching Offers for order $orderId: $e');
    }
  }

  int current = 0;
  final PageController pageController = PageController();

  Widget offerCard(Offer offer) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                       backgroundImage: NetworkImage(offer.user.imageUrl)
                    ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text(offer.user.name),
                     ),
                  ],
                ),
               
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Needed car piece: ${offer.piece}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        'Car type: ${offer.yearModel}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Piece condition: ${offer.condition}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Near places: ${offer.country}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Price: ${offer.price}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Address: ${offer.notes}', // Assuming 'notes' contains address information
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < (offer.user.avgRating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            CustomButton3(text: 'Accept', onPressed: () {}),
            SizedBox(width: 20),
            CustomButton4(
                text: 'Decline',
                onPressed: () {
                  // declineOrder(order.id);
                })
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [BackButton()],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Offer Requests',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepPurple)),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Offers',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.deepPurple)),
                  ],
                ),
              ),
              Obx(() {
                List<Widget> orderWidgets = [];
                bool hasOffers = false;

                offers.forEach((orderId, offersList) {
                  if (offersList.isNotEmpty) {
                    hasOffers = true;
                    orderWidgets.add(Text("Offers for Order : $orderId",
                        style: TextStyle(fontWeight: FontWeight.w500)));
                    orderWidgets.addAll(offersList
                        .map((offer) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VenforProfile()));
                              },
                              child: offerCard(offer),
                            ))
                        .toList());
                  }
                });

                if (!hasOffers) {
                  orderWidgets.add(
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No offers for this moment',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Column(children: orderWidgets);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class Offer {
  final int id;
  final String piece;
  final String country;
  final String yearModel;
  final String condition;
  final String price;
  final String notes;
  final String isAccepted;
  final User user;

  Offer({
    required this.id,
    required this.piece,
    required this.country,
    required this.yearModel,
    required this.condition,
    required this.price,
    required this.notes,
    required this.isAccepted,
    required this.user,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as int,
      piece: json['piece'] as String,
      country: json['country'] as String,
      yearModel: json['year_model'] as String,
      condition: json['condition'] as String,
      price: json['price'] as String,
      notes: json['notes'] as String,
      isAccepted: json['is_accepted'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class User {
  final int id;
  final String name;
  final String imageUrl;
  final double? avgRating;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.avgRating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as dynamic,
      avgRating: json['avg_rating'] != null
          ? (json['avg_rating'] as num?)?.toDouble()
          : null,
    );
  }
}


