import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/client/payment.dart';
import '../../widgets/custom_button.dart';
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
  Map<int, bool> canDownloadOffersMap = {};
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  
  }

  Future<bool> checkCanDownloadOffers() async {
    bool canDownload = false;
    for (var orderId in widget.orderIds) {
      await fetchOffers(orderId);
      canDownload |= canDownloadOffersMap[orderId] ?? false;
    }
    return canDownload;
  }

  Future<void> fetchAllOffers() async {
    for (var orderId in widget.orderIds) {
      await fetchOffers(orderId);
    }
    offers.refresh();
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
        bool canDownload = jsonResponse['can_download_offers'] ?? false;
        canDownloadOffersMap[orderId] = canDownload;
        if (jsonResponse['offers'] is List) {
          List<dynamic> jsonList = jsonResponse['offers'];
          var fetchedOffers =
              jsonList.map((json) => Offer.fromJson(json)).toList();
          if (fetchedOffers.isNotEmpty) {
            offers[orderId] = fetchedOffers;
          }
        }
      } else {
        // Handle error
        print('Failed to fetch offers');
        print(response.body);
      }
    } catch (e) {
      print('Error occurred while fetching offers: $e');
    }
  }

  Future<void> declineOffer(int offerId) async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/client/orders/offers/$offerId/decline");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.post(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          // Offer has been declined successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Offer $offerId has been declined successfully'),
            ),
          );
          await Future.delayed(Duration(seconds: 1));

          // Trigger a rebuild of the UI
          setState(() {
            offers.removeWhere((orderId, offersList) {
              return offersList.any((offer) => offer.id == offerId);
            });
          });
        }
      } else {
        // Handle error

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to decline offer')),
        );
      }
    } catch (e) {
      // Handle any exceptions here

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while declining offer')),
      );
    }
  }

Future<void> requestStoragePermission() async {
  PermissionStatus status = await Permission.manageExternalStorage.request();

  if (status.isGranted) {
    print("Permission granted");
    // Proceed with file operations
    savePdf(widget.orderIds);
  } else if (status.isDenied) {
    print("Permission denied");
    // Handle permission denied (show a message to the user)
   
  } else if (status.isPermanentlyDenied) {
    print("Permission permanently denied");
    // Handle permanent denial (show a dialog to guide the user)
    showPermissionPermanentlyDeniedDialog();
  }
}
void showPermissionPermanentlyDeniedDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Permission Required"),
        content: Text("Please enable storage permission in the app settings."),
        actions: <Widget>[
          TextButton(
            child: Text("Open Settings"),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




  Future<void> savePdf(List<int> orderIds) async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/orders/${orderIds[0]}/offers/download");
    isLoading(true);
    try {
      final status = await Permission.manageExternalStorage.request();

      if (status.isGranted) {
        final response = await http.get(
          apiEndpoint,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );

        if (response.statusCode == 200) {
          final directory = await getExternalStorageDirectory();
          final filePath = '${directory?.path ?? ''}/offers_${orderIds[0]}.pdf';
          final file = File(filePath);

          await file.writeAsBytes(response.bodyBytes);

          // Check if the file exists before attempting to open it
          if (await file.exists()) {
            final result = await OpenFile.open(filePath);
            if (result.type != ResultType.done) {
              throw Exception('Failed to open the file: ${result.message}');
            }
          } else {
            throw Exception('File does not exist at path: $filePath');
          }
        } else {
          Get.snackbar(
            "Download Error",
            "Failed to download the PDF. Status code: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM,
          );
          print('Failed to download PDF. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } else {
        Get.snackbar(
          "Permission Denied",
          "Permission to manage external storage is required to download PDF.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Download Error",
        "Failed to download the PDF. Error: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error during PDF download: $e');
    } finally {
      isLoading(false);
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
                        backgroundImage: NetworkImage(offer.user.imageUrl)),
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
                            color: Colors.orange,
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
        if (offer.isAccepted == '0') ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton3(
                text: 'Accept',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payment(
                        offerId: offer.id,
                        price: offer.price,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 20),
              CustomButton4(
                text: 'Decline',
                onPressed: () {
                  declineOffer(offer.id);
                },
              ),
            ],
          ),
        ] else if (offer.isAccepted == '1') ...[
          CustomButton5(
            text: 'Accepted Order',
            onPressed: () {},
          ),
        ],
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
              FutureBuilder<bool>(
                future: checkCanDownloadOffers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  // Build the offer list widgets here
                  List<Widget> offerWidgets = _buildOfferList();

                  // Check and add the Download PDF button at the end
                  if (snapshot.data == true) {
                    offerWidgets.add(
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CustomButton(
                          text: 'Download PDF',
                          onPressed: () {
                            if (widget.orderIds.isNotEmpty) {
                              savePdf(widget.orderIds);
                            } else {
                              Get.snackbar(
                                "Download Error",
                                "Failed to download the PDF. Error: No orders found",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }

                  return Column(children: offerWidgets);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOfferList() {
    List<Widget> offerWidgets = [];

    offers.forEach((orderId, offersList) {
      if (offersList.isNotEmpty) {
        offerWidgets.add(Text("Offers for Order : $orderId",
            style: TextStyle(fontWeight: FontWeight.w500)));
        offerWidgets.addAll(offersList
            .map((offer) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VenforProfile(userId: offer.user.id)));
                  },
                  child: offerCard(offer),
                ))
            .toList());
      }
    });

    if (offerWidgets.isEmpty) {
      offerWidgets.add(Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text('No offers at this moment',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
        ),
      ));
    }

    return offerWidgets;
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
  final bool canDownloadOffers;

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
    this.canDownloadOffers = false,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      piece: json['piece'].toString(),
      country: json['country'].toString(),
      yearModel: json['year_model'].toString(),
      condition: json['condition'].toString(),
      price: json['price'].toString(),
      notes: json['notes'].toString(),
      isAccepted: json['is_accepted'].toString(),
      user: User.fromJson(json['user']),
      canDownloadOffers: json['can_download_offers'] ?? false,
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
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      avgRating: double.tryParse(json['avg_rating']?.toString() ?? '0'),
    );
  }
}
