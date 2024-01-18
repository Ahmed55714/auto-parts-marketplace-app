import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../generated/l10n.dart';
import '../../getx/orders.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../client/orders_clint.dart';
import 'Registration_form.dart';
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
  //late StreamController<List<Order>> _streamController;
  Future<List<Order>>? _futureOrders;

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
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Order.fromJson(json)).toList();
      } else {
        print('Failed to load orders, Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load orders, Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching orders: $e');
      throw Exception('Error occurred while fetching orders');
    }
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
        refreshOrders();
      } else {}
    } catch (e) {}
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
        refreshOrders();
      } else {}
    } catch (e) {}
  }

  void refreshOrders() async {
    setState(() {
      _futureOrders = fetchOrders();
    });
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
        refreshOrders();
      } else {}
    } catch (e) {}
  }

  Future<int> fetchUnreadMessageCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    final Uri apiEndpoint =
        Uri.parse("https://slfsparepart.com/api/chat/inbox/unread/count");
    final response = await http.get(
      apiEndpoint,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['unread_count'];
    } else {
      throw Exception('Failed to load unread count: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUnreadMessageCount();
    //_streamController = StreamController<List<Order>>.broadcast();
    // _startListeningToOrders();
    // _startFetchingOrders();
    _futureOrders = fetchOrders();
  }

  void _startListeningToOrders() {
    Timer.periodic(Duration(seconds: 3), (timer) async {
      var orders = await fetchOrders();
      // _streamController.add(orders);
    });
  }

  @override
  void dispose() {
    //_streamController.close();
    super.dispose();
  }

  //Stream<List<Order>> get ordersStream => _streamController.stream;

  final OrdersController orderController = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<RegistrationVerificationStatus>(
      future: fetchCompleteRegistrationStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(S.of(context).Try)),
          );
        } else if (snapshot.hasData) {
          var status = snapshot.data!;
          if (status.completeRegistration == "1" && status.isVerified == "1") {
            return buildOrdersLayout(); // Replace with your orders layout
          }
           else if (status.completeRegistration == "1" &&
              status.isVerified == "0") {
            return Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      S.of(context).Re3,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: deepPurple),
                    ),
                  ),
                ),
              ),
            );
          }
          else if (status.completeRegistration == "0" &&
              status.isVerified == "0") {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Container(
                        width: 300,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.9, // Adjust the width as needed
                              child: Text(
                                S.of(context).Re,
                                textAlign:
                                    TextAlign.center, // Center align the text
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                  color: greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: S.of(context).Re2,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                             RegistrationForm(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return buildOrdersLayout();
      },
    );
  }

  Widget buildOrdersLayout() {
    var textDirection = Directionality.of(context);

  // Adjust padding based on text direction
  var errorPadding = textDirection == ui.TextDirection.ltr
      ? const EdgeInsets.only(left: 16)
      : const EdgeInsets.only(right: 16);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    Text(
                      S.of(context).Orders,
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
                              icon: Stack(
                                children: <Widget>[
                                  Icon(Icons.notifications,
                                      size: 35, color: deepPurple),
                                  FutureBuilder<int>(
                                    future:
                                        fetchUnreadMessageCount(), // your fetch function here
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data! > 0) {
                                        return Positioned(
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            constraints: BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //...orders.map((order) => orderDetails(order)).toList(),

              FutureBuilder<List<Order>>(
                future: _futureOrders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(S.of(context).error));
                  } else if (snapshot.hasData) {
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
                    return Center(child: Text(S.of(context).error2));
                  }
                },
              ),
            ],
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
                  title: S.of(context).Needed,
                  placeholder: order.carPiece,
                ),
                OrderDetailLine(
                  title: S.of(context).CarModel,
                  placeholder: order.carModel,
                ),
                OrderDetailLine(
                  title: S.of(context).Chassis,
                  placeholder: order.chassisNumber,
                ),
                OrderDetailLine(
                  title: S.of(context).pieceType,
                  placeholder: order.pieceType,
                ),
                OrderDetailLine(
                  title: S.of(context).pieceDetails,
                  placeholder: order.pieceDetail,
                ),
                OrderDetailLine(
                  title: S.of(context).Date,
                  placeholder: DateFormat('yyyy-MM-dd').format(order.date),
                ),
                OrderDetailLine(
                  title: S.of(context).carLicence,
                  placeholder: 'Show Image',
                  imageUrl:
                      order.files.isNotEmpty ? order.files[0].fileUrl : null,
                  imageUrl2:
                      order.files.length > 1 ? order.files[1].fileUrl : null,
                ),
                OrderDetailLine(
                  title: S.of(context).nearPlaces,
                  placeholder: 'Show Location',
                  location: LatLng(order.latitude, order.longitude),
                ),
                OrderDetailLine(
                  title: S.of(context).orderStatus,
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
            text: S.of(context).Outfordelivery,
            onPressed: () {
              updateOrderStatus(order.id);
              setState(() {});
            },
          )
        else if (isOrderOutForDelivery)
          CustomButton(
            text: S.of(context).Delivered,
            onPressed: () async {
              await markOrderAsDelivered(order.id);

              setState(() {});
            },
          )
        else if (isOrderDelivered)
          // Display a message or UI element indicating that the order is already delivered
          Text(
            S.of(context).DeleverdText,
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
                text: S.of(context).makeoffer,
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
                text: S.of(context).Decline,
                onPressed: () {
                  declineOrder(order.id);
                  setState(() {});
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
              Text(
                S.of(context).Are,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
              Text(
                S.of(context).Are2,
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
                  labelText: S.of(context).comment,
                  controller: cancelReasonController,
                ),
              ),
              CustomButton(
                text: S.of(context).Done,
                onPressed: () {
                  String cancelReason = cancelReasonController.text;
                  if (cancelReason.isNotEmpty) {
                    widget.onConfirmCancel(cancelReason, widget.orderId);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.of(context).Please),
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
        title == S.of(context).nearPlaces && placeholder == 'Show Location';

    bool isImageLine =
        title == S.of(context).carLicence && placeholder == 'Show Image';
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LocationViewScreen(location: location!),
                                settings: RouteSettings(arguments: location)));
                      }
                    },
                    child: Text(
                      S.of(context).ShowLocation,
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewScreen(),
                                        settings: RouteSettings(
                                            arguments: imageUrl)));
                              }
                            },
                            child: Text(
                              S.of(context).Image1,
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewScreen(),
                                        settings: RouteSettings(
                                            arguments: imageUrl2)));
                              }
                            },
                            child: Text(
                              S.of(context).Image2,
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
  bool bottomSheetShown = false;
  bool rated;
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
    this.bottomSheetShown = false,
    this.rated = false,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      carPiece: json['car_piece'].toString(),
      carModel: json['car_model'].toString(),
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
      bottomSheetShown: false,
      rated: json['rated'] ?? false,
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
