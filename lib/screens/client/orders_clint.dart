import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/client/car_form.dart';
import '../../constants/colors.dart';
import '../../getx/orders.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import 'bottom_cheet.dart';
import 'offer_client.dart';

class OrdersClient extends StatefulWidget {
  const OrdersClient({super.key});

  @override
  State<OrdersClient> createState() => _OrdersClientState();
}

class _OrdersClientState extends State<OrdersClient> {
  var orders = <Order>[].obs;
  
  int selectedContainerIndex = -1;

 Future<List<Order>> fetchOrders() async {
  final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/client/orders?");
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
      List<dynamic> jsonList = jsonDecode(response.body);
      var fetchedOrders = jsonList.map((json) => Order.fromJson(json)).toList();
      return fetchedOrders; // Return the list of orders here
    } else {
      // Handle error
      print('Failed to fetch orders: ${response.body}');
      throw Exception('Failed to load orders');
    }
  } catch (e) {
    // Handle any exceptions here
    print('Error occurred while fetching orders: $e');
    throw Exception('Error fetching orders');
  }
}

  Future<void> _refresh() async {
    await fetchOrders();
  }

  Future<void> cancelOrder(String cancelReason, int orderId) async {
    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/client/orders/$orderId/cancel");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.post(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {'cancel_reason': cancelReason},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        if (responseData['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order $orderId has been cancelled successfully'),
            ),
          );
          fetchOrders();
        }
      } else {
        // Handle error
        print('Failed to cancel order. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel order')),
        );
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while cancelling order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while cancelling order')),
      );
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

  List<int> getOrderIds() {
    return orders.map((order) => order.id).toList();
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomContainerButton(
                      text: "New Request",
                      onPressed: () {
                        //List<int> orderIds = getOrderIds();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CarForm()));
                      },
                      svgIconPath:
                          'assets/images/+.svg', // Replace with the actual path to your SVG file
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                //...orders.map((order) => orderDetails(order)).toList(),

               FutureBuilder<List<Order>>(
                future: fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No orders available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return orderDetails(snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
              ],
            ),
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
        order.status == 'Canceled'
            ? CancelOrderSection()
            : CustomButton2(
                text: 'Cancel order',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return BottomcancelSheetWidget(
                        orderId: order.id,
                        onConfirmCancel: (cancelReason, orderId) async {
                          await cancelOrder(cancelReason, orderId);
                          fetchOrders();
                        },
                      );
                    },
                  );
                },
              ),
        SizedBox(height: 10),
        order.status != 'Canceled'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainerButton(
                    svgIconPath: 'assets/images/offerr.svg',
                    text: "Check Offers",
                    onPressed: () {
                      //List<int> orderIds = getOrderIds();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OfferClient(orderIds: [order.id])));
                    },
                    // Replace with the actual path to your SVG file
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
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
                       Navigator.push(context, MaterialPageRoute(builder: (context) => LocationViewScreen( 
                          location: location!)
                       , settings: RouteSettings(arguments: location)));
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewScreen(), settings: RouteSettings(arguments: imageUrl)));
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewScreen(), settings: RouteSettings(arguments: imageUrl2)));                              }
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
                          color:
                              isCanceledStatus ? Colors.red : Colors.grey[600],
                        ),
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


class ImageViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)!.settings.arguments as String?;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Image View'),
      ),
      body: Center(
        child: imageUrl != null
            ? Image.network(imageUrl)
            : Text('Image not available'),
      ),
    );
  }
}

class LocationViewScreen extends StatelessWidget {
  final LatLng location;

  LocationViewScreen({required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location View'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 14.0,
        ),
        markers: {Marker(markerId: MarkerId('loc'), position: location)},
      ),
    );
  }
}
