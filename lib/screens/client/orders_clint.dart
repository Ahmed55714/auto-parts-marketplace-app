// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../../getx/orders.dart';
import '../../getx/regestration.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../vendor/chat/screens/mobile_layout_screen.dart';
import 'bottom_cheet.dart';
import 'offer_client.dart';
import 'order_repo.dart';

class OrdersClient extends StatefulWidget {
  OrdersClient({
    Key? key,
     
  }) : super(key: key);

  @override
  State<OrdersClient> createState() => _OrdersClientState();
}

class _OrdersClientState extends State<OrdersClient> {
  var orders = <Order>[].obs;
  final RegesterController regesterController = Get.find<RegesterController>();
  int selectedContainerIndex = -1;
  final StreamController<List<Order>> _ordersStreamController =
      StreamController();
  bool _orderSubmitted = false;

  // void markOrderAsSubmitted(int orderId) {
  //   setState(() {
  //     var orderIndex = orders.indexWhere((order) => order.id == orderId);
  //     if (orderIndex != -1) {
  //       var updatedOrder = orders[orderIndex].copyWith(isSubmitted: true);
  //       orders[orderIndex] = updatedOrder;
  //     }
  //   });
  // }

  Future<List<Order>> fetchOrders() async {
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
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) {
          bool rated = prefs.getBool('order_rated_${json['id']}') ?? false;
          return Order.fromJson(json);
        }).toList();
      } else {
        // Handle error
        print(response.body);
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      // Handle any exceptions here
      print(e);
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

        if (responseData['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${S.of(context).Orders} $orderId ${S.of(context).AreCancel6}'),
            ),
          );
          setState(() {
            fetchOrders();
          });
        }
      } else {
        // Handle error

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).AreCancel5)),
        );
      }
    } catch (e) {
      // Handle any exceptions here

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('')),
      );
    }
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
    fetchOrders().then((fetchedOrders) {
      for (var order in fetchedOrders) {
        if (order.status == "Delivered" && !order.rated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showModalBottomSheet(
              context: context,
              builder: (context) => BottomSheetWidget(orderId: order.id),
            ).then((_) {
              setState(() {
                order.rated = true;
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('order_rated_${order.id}', true);
                });
              });
            });
          });
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refresh();
      }
    });
  }

  final OrdersController orderController = Get.put(OrdersController());

  List<int> getOrderIds() {
    return orders.map((order) => order.id).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      S.of(context).Orders,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: deepPurple,
                      ),
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
                              Icon(
                                Icons.notifications,
                                color: deepPurple,
                                size: 35,
                              ),
                              FutureBuilder<int>(
                                future:
                                    fetchUnreadMessageCount(), // your fetch function here
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.hasData && snapshot.data! > 0) {
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainerButton(
                        text: S.of(context).NewRequest,
                        onPressed: () {
                          //List<int> orderIds = getOrderIds();
                          regesterController.navigateBasedClint2(context);
                        },
                        svgIconPath: 'assets/images/+.svg',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Order>>(
                    future: fetchOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(S.of(context).NoOrdersAvailable));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text(S.of(context).NoOrdersAvailable));
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
                  title: S.of(context).Needed,
                  placeholder: order.carPiece,
                ),
                OrderDetailLine(
                  title: S.of(context).CarModel,
                  placeholder: order.carModel.toString(),
                ),
                OrderDetailLine(
                  title: S.of(context).Chassis,
                  placeholder: order.chassis.number,
                ),
                OrderDetailLine(
                  title: S.of(context).pieceType,
                  placeholder: order.pieceTypes
                      .map((pieceType) => pieceType.name)
                      .join(', '),
                ),
                OrderDetailLine(
                  title: S.of(context).pieceDetails,
                  placeholder: order.pieceDetails
                      .map((pieceDetail) => pieceDetail.name)
                      .join(', '),
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
        if (order.status == 'Delivered' )
          CustomButton(
            text: S.of(context).AreCancel7,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderRepo(
                    orderId: order.id,
                  ),
                ),
              );
            },
          )
        // else if (order.isSubmitted)
        //   CustomButton2(
        //     text: S.of(context).Done,
        //     onPressed: () {},
        //   )
        else if (order.status != 'Canceled')
          CustomButton2(
            text: S.of(context).CancelOrder,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BottomcancelSheetWidget(
                    orderId: order.id,
                    onConfirmCancel: (cancelReason, orderId) async {
                      await cancelOrder(cancelReason, orderId);
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
                    text: S.of(context).CheckOffers,
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
      height: MediaQuery.of(context).size.height * 0.9,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Text(
                S.of(context).CancelOrder,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
              Text(
                S.of(context).AreCancel2,
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
                        content: Text(S.of(context).AreCancel3),
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
    bool isAcceptedOrDelivered =
        placeholder == 'Accepted' || placeholder == 'Delivered';
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
      return Colors.green;
    case 'Canceled':
      return Colors.red;
    default:
      return Colors.grey[600]!;
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
            CustomButton5(text: S.of(context).CancelOrder, onPressed: () {}),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 1),
        ),
        Text(S.of(context).AreCancel4,
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
  final int carModel;
  final bool forGovernment;
  final String status;
  final double latitude;
  final double longitude;
  final Chassis chassis;
  final List<PieceType> pieceTypes;
  final List<PieceDetail> pieceDetails;
  final Car car;
  final String? address;
  final dynamic rating; // Assuming rating can be different types or null
  bool rated;

  Order({
    required this.id,
    required this.carPiece,
    required this.carModel,
    required this.forGovernment,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.chassis,
    required this.pieceTypes,
    required this.pieceDetails,
    required this.car,
    this.address,
    this.rating,
    this.rated = false,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      carPiece: json['car_piece'],
      carModel: json['car_model'],
      forGovernment: json['for_government'] == 1,
      status: json['status'],
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['long']),
      chassis: Chassis.fromJson(json['chassis']),
      pieceTypes: List<PieceType>.from(json['piece_types'].map((x) => PieceType.fromJson(x))),
      pieceDetails: List<PieceDetail>.from(json['piece_details'].map((x) => PieceDetail.fromJson(x))),
      car: Car.fromJson(json['car']),
      address: json['address'],
      rating: json['rating'],
      rated: false, // Default to false, adjust based on your logic
    );
  }
}

class Chassis {
  final String type;
  final String number;

  Chassis({required this.type, required this.number});

  factory Chassis.fromJson(Map<String, dynamic> json) {
    return Chassis(
      type: json['type'],
      number: json['number'],
    );
  }
}

class PieceType {
  final int id;
  final String name;

  PieceType({required this.id, required this.name});

  factory PieceType.fromJson(Map<String, dynamic> json) {
    return PieceType(
      id: json['id'],
      name: json['name'],
    );
  }
}

class PieceDetail {
  final int id;
  final String name;

  PieceDetail({required this.id, required this.name});

  factory PieceDetail.fromJson(Map<String, dynamic> json) {
    return PieceDetail(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Car {
  final int id;
  final String name;

  Car({required this.id, required this.name});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageUrl = ModalRoute.of(context)!.settings.arguments as String?;

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).ImageView)),
        body: Center(
          child: imageUrl != null
              ? Image.network(imageUrl)
              : Text(S.of(context).Imagenot),
        ),
      ),
    );
  }
}

class LocationViewScreen extends StatelessWidget {
  final LatLng location;

  LocationViewScreen({required this.location});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).LocationView),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: location,
            zoom: 14.0,
          ),
          markers: {Marker(markerId: MarkerId('loc'), position: location)},
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}
