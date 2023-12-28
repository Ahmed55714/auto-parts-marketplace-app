import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart';
import '../../getx/orders.dart';
import '../../widgets/custom_button.dart';
import 'offer_client.dart';

class OrdersClient extends StatefulWidget {
  const OrdersClient({super.key});

  @override
  State<OrdersClient> createState() => _OrdersClientState();
}

class _OrdersClientState extends State<OrdersClient> {
  List<Order> orders = [];
  int selectedContainerIndex = -1;

  Future<void> fetchOrders() async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/client/orders?");
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
        setState(() {
          orders = jsonList.map((json) => Order.fromJson(json)).toList();
        });
      } else {
        // Handle error
        print('Failed to fetch orders');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while fetching orders: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final OrdersController orderController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              const Center(
                child: Text(
                  'Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainerButton(
                    text: "New Request",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfferClient()));
                    },
                    svgIconPath:
                        'assets/images/+.svg', // Replace with the actual path to your SVG file
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...orders.map((order) => orderDetails(order)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderDetails(Order order) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
                  placeholder: 'show image',
                ),
                OrderDetailLine(
                  title: 'Near places',
                  placeholder: 'show map',
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
        CustomButton2(text: 'Cancel order', onPressed: () {}),
      ],
    );
  }
}

class OrderDetailLine extends StatelessWidget {
  final String title;
  final String placeholder;
  final Color? placeholderColor;

  const OrderDetailLine({
    Key? key,
    required this.title,
    required this.placeholder,
    this.placeholderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  placeholder,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: placeholderColor ?? greyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
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
        const SizedBox(height: 20),
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
