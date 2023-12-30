import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../getx/orders.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import 'chat/screens/mobile_layout_screen.dart';
import 'offer_form.dart';

class RegistrationVerificationStatus {
  final String completeRegistration;
  final String isVerified;

  RegistrationVerificationStatus(
      {required this.completeRegistration, required this.isVerified});
}

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Future<RegistrationVerificationStatus>
      fetchCompleteRegistrationStatus() async {
    var url = Uri.parse('https://slfsparepart.com/api/user');
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return RegistrationVerificationStatus(
          completeRegistration:
              jsonResponse['complete_registration'].toString(),
          isVerified: jsonResponse['is_verified'].toString(),
        );
      } else {
        throw Exception('Failed to load registration status');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }

  var orders = <Order>[].obs;
  int selectedContainerIndex = -1;

  Future<List<Order>> fetchOrders() async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/vendor/orders");
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
        print('Response data: ${response.body}');
        List<dynamic> jsonList = jsonDecode(response.body);
        var fetchedOrders =
            jsonList.map((json) => Order.fromJson(json)).toList();
        return fetchedOrders; // Return the list of orders
      } else {
        // Handle error
        print('Failed to fetch orders');
        print(response.body);
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while fetching orders: $e');
      throw Exception('Error occurred while fetching orders');
    }
  }

  Future<void> _refresh() async {
    await fetchOrders();
  }

  Future<void> declineOrder(int orderId) async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/vendor/orders/$orderId/decline");
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
          'id': orderId.toString(),
        },
      );

      if (response.statusCode == 200) {
        print('Order declined successfully');
        await fetchOrders();
      } else {
        // Handle error
        print('Failed to decline order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while declining order: $e');
    }
  }

  Future<void> updateOrderStatus(int orderId) async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/vendor/orders/${orderId}/update");
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
          'status': 'Out for Delivery',
        },
      );

      if (response.statusCode == 200) {
        print('Order status updated to "Out for Delivery" successfully');
        print(response.body);
        await fetchOrders();
      } else {
        print(
            'Failed to update order status. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error occurred while updating order status: $e');
    }
  }

  Future<void> markOrderAsDelivered(int orderId) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/vendor/orders/$orderId/update");
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
          'status': 'Delivered',
        },
      );

      if (response.statusCode == 200) {
        print('Order status updated to "Delivered" successfully');
        print(response.body);
      } else {
        print(
            'Failed to update order status to "Delivered". Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error occurred while updating order status to "Delivered": $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch orders when the widget is first created
    fetchOrders();
    Timer.periodic(Duration(minutes: 5), (Timer timer) {
      fetchOrders();
    });
  }

  final OrdersController orderController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                Center(
                  child: Column(
                    children: [
                      Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MobileLayoutScreen()));
                              },
                              icon: const Icon(
                                Icons.notifications,
                                color: deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //...orders.map((order) => orderDetails(order)).toList(),

                FutureBuilder<List<Order>>(
                  future: fetchOrders(), // Replace with your future function
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for data, show a circular progress indicator
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // If there's an error, display an error message
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      // If data is available, build the ListView.builder
                      var orders = snapshot.data!;
                      return ListView.builder(
                        itemCount: orders.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return orderDetails(orders[index]);
                        },
                      );
                    } else {
                      // Handle other cases here (e.g., when data is null)
                      return Center(child: Text('No data available'));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderDetails(Order order) {
    bool isOrderAccepted = order.status == 'Accepted';
    bool isOrderOutForDelivery = order.status == 'Out for Delivery';
    bool isOrderDelivered = order.status == 'Delivered';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 46, 238).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.deepPurple, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${order.id}', // Display the order number here
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
                SizedBox(height: 8),
                OrderDetailLine(
                  title: 'Needed car piece',
                  placeholder: order.carPiece,
                ),
                OrderDetailLine(
                  title: 'Car model',
                  placeholder: order.carModel,
                ),
                OrderDetailLine(
                  title: 'Chassis number',
                  placeholder: order.chassisNumber,
                ),
                OrderDetailLine(
                  title: 'Piece type',
                  placeholder: order.pieceType,
                ),
                OrderDetailLine(
                  title: 'Piece details',
                  placeholder: order.pieceDetail,
                ),
                OrderDetailLine(
                  title: 'Date',
                  placeholder: DateFormat('yyyy-MM-dd').format(order.date),
                ),
                OrderDetailLine(
                  title: 'Car Licence',
                  placeholder: 'Show Image',
                  imageUrl:
                      order.files.isNotEmpty ? order.files[0].fileUrl : null,
                  imageUrl2:
                      order.files.length > 1 ? order.files[1].fileUrl : null,
                ),
                OrderDetailLine(
                  title: 'Near places',
                  placeholder: 'Show Location',
                  location: LatLng(order.latitude, order.longitude),
                ),
                OrderDetailLine(
                  title: 'Order Status',
                  placeholder: order.status,
                  placeholderColor:
                      order.status == 'Pending' ? Colors.red : Colors.green,
                ),
              ],
            ),
          ),
        ),
        if (isOrderAccepted)
          CustomButton(
            text: 'Out for delivery',
            onPressed: () {
              updateOrderStatus(order.id);
              setState(() {});
            },
          )
        else if (isOrderOutForDelivery)
          CustomButton(
            text: 'Delivered',
            onPressed: () async {
              await markOrderAsDelivered(order.id);

              setState(() {});
            },
          )
        else if (isOrderDelivered)
          // Display a message or UI element indicating that the order is already delivered
          Text(
            'Order is already delivered',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: deepPurple,
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton3(
                text: 'Accept',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OfferForm(orderId: order.id.toString()),
                    ),
                  );
                },
              ),
              SizedBox(width: 20),
              CustomButton4(
                text: 'Decline',
                onPressed: () {
                  declineOrder(order.id);
                },
              ),
            ],
          ),
      ],
    );
  }
}

void _showImageDialog(BuildContext context, String? imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                imageUrl ?? '',
                fit: BoxFit.cover,
              )));
    },
  );
}

class BottomcancelSheetWidget extends StatefulWidget {
  final int orderId;
  final Function(String, int) onConfirmCancel;

  BottomcancelSheetWidget({
    Key? key,
    required this.orderId,
    required this.onConfirmCancel,
  }) : super(key: key);

  @override
  _BottomcancelSheetWidgetState createState() =>
      _BottomcancelSheetWidgetState();
}

class _BottomcancelSheetWidgetState extends State<BottomcancelSheetWidget> {
  final TextEditingController cancelReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9, // 60% of screen height

      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Text(
                'Are you sure you want to cancel Your Order?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
              const Text(
                'Can you tell us the reason?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: 'Roboto'),
              ),
              const SizedBox(height: 10.0),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 70,
                child: CustomMultiLineFormField(
                  labelText: 'comment',
                  controller: cancelReasonController,
                ),
              ),
              CustomButton(
                text: 'Done',
                onPressed: () {
                  String cancelReason = cancelReasonController.text;
                  if (cancelReason.isNotEmpty) {
                    widget.onConfirmCancel(cancelReason, widget.orderId);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please provide a reason for cancellation'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailLine extends StatelessWidget {
  final String title;
  final String placeholder;
  final Color? placeholderColor;
  final String? imageUrl;
  final String? imageUrl2;
  final LatLng? location;
  final VoidCallback? onTap;

  const OrderDetailLine({
    Key? key,
    required this.title,
    required this.placeholder,
    this.placeholderColor,
    this.imageUrl,
    this.imageUrl2,
    this.location,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = _getTextColorBasedOnStatus(placeholder);
    bool isLocationLine =
        title == 'Near places' && placeholder == 'Show Location';
    bool isImageLine = title == 'Car Licence' && placeholder == 'Show Image';
    bool isCanceledStatus =
        title == 'Order Status' && placeholder == 'Canceled';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(right: 0),
            child: isLocationLine
                ? InkWell(
                    onTap: () {
                      if (location != null) {
                        _showMapDialog(context, location!);
                      }
                    },
                    child: Text(
                      placeholder,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : isImageLine
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (imageUrl != null && imageUrl!.isNotEmpty) {
                                _showImageDialog(context, imageUrl!);
                              }
                            },
                            child: Text(
                              'Image 1',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              if (imageUrl2 != null && imageUrl2!.isNotEmpty) {
                                _showImageDialog(context, imageUrl2!);
                              }
                            },
                            child: Text(
                              'Image 2', // Display the second image text
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        placeholder,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: textColor,
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

Color _getTextColorBasedOnStatus(String status) {
  switch (status) {
    case 'Accepted':
    case 'Delivered':
    case 'Out for Delivery':
      return Colors.green;
    case 'Canceled':
      return Colors.red;
    default:
      return Colors.grey[600]!;
  }
}

void _showMapDialog(BuildContext context, LatLng location) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 14.0,
            ),
            markers: {Marker(markerId: MarkerId('loc'), position: location)},
          ),
        ),
      );
    },
  );
}

class CancelOrderSection extends StatelessWidget {
  const CancelOrderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton5(text: 'Cancel Order', onPressed: () {}),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 1),
        ),
        Text('Your order has been canceled.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: greyColor,
            )),
        const SizedBox(height: 10)
      ],
    );
  }
}

class CustomContainerButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String svgIconPath; // Path to your SVG icon

  const CustomContainerButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.svgIconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 20 * 17,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.deepPurple, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgIconPath,
              color: Colors.deepPurple,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.26,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Order {
  final int id;
  final String carPiece;
  final String carModel;
  final String chassisNumber;
  final DateTime date;
  final String status;
  final String pieceType;
  final String pieceDetail;
  final bool forGovernment;
  final double latitude;
  final double longitude;
  final String carName;
  final String pieceTypeName;
  final String pieceDetailName;
  final String? address;
  final List<File> files;

  Order({
    required this.id,
    required this.carPiece,
    required this.carModel,
    required this.chassisNumber,
    required this.date,
    required this.status,
    required this.pieceType,
    required this.pieceDetail,
    required this.forGovernment,
    required this.latitude,
    required this.longitude,
    required this.carName,
    required this.pieceTypeName,
    required this.pieceDetailName,
    this.address,
    required this.files,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      carPiece: json['car_piece'],
      carModel: json['car_model'],
      chassisNumber: json['chassis_number'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      pieceType: json['piece_type']['name'],
      pieceDetail: json['piece_detail']['name'],
      forGovernment: json['for_government'] == "1",
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['long']),
      carName: json['car']['name'],
      pieceTypeName: json['piece_type']['name'],
      pieceDetailName: json['piece_detail']['name'],
      address: json['address'],
      files: (json['files'] as List)
          .map((fileJson) => File.fromJson(fileJson))
          .toList(),
    );
  }
}

class File {
  final int id;
  final String fileUrl;

  File({
    required this.id,
    required this.fileUrl,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
      fileUrl: json['file_url'],
    );
  }
}



//  @override
// Widget build(BuildContext context) {
//   return FutureBuilder<RegistrationVerificationStatus>(
//     future: fetchCompleteRegistrationStatus(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//       } else if (snapshot.hasError) {
//         return Scaffold(
//           body: Center(child: Text('Error: ${snapshot.error}')),
//         );
//       } else if (snapshot.hasData) {
//         var status = snapshot.data!;
//         if (status.completeRegistration == "1" && status.isVerified == "1") {
//           return buildOrdersLayout();
//         } else if (status.completeRegistration == "1" && status.isVerified == "0") {
//           return const Scaffold(
//             body: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'Your application is under review, please wait for the approval',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: deepPurple),
//                 ),
//               ),
//             ),
//           );
//         } else if (status.completeRegistration == "0" && status.isVerified == "0") {
//           return const Scaffold(
//             body: Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Text(
//                   'Registration to be able to see orders',
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: deepPurple),
//                 ),
//               ),
//             ),
//           );
//         }
//       }
//       return const Scaffold(
//         body: Center(child: Text('No data available')),
//       );
//     },
//   );
// }


 