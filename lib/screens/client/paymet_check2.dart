import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/widgets/custom_button.dart';
import '../../getx/orders.dart';
import '../../widgets/custom_continer.dart';
import '../vendor/Bottom_nav.dart';
import 'orders_clint.dart';

class PaymentOfferCheck2 extends StatefulWidget {

  final String carPiece;
  final List<String> carTypeIds;
  final String carModelIds;
  final String chassisNumber;
  final List<String> pieceType;
  final List<String> pieceDetail;
  final List<XFile> images;
  final String birthDate;
  final String latitude;
  final String longitude;
  final String forGovernment;

  const PaymentOfferCheck2({
    Key? key,
    required this.carPiece,
    required this.carTypeIds,
    required this.carModelIds,
    required this.chassisNumber,
    required this.pieceType,
    required this.pieceDetail,
    required this.images,
    required this.birthDate,
    required this.latitude,
    required this.longitude,
    required this.forGovernment,
  }) : super(key: key);

  @override
  State<PaymentOfferCheck2> createState() => _PaymentOfferCheckState();
}

class _PaymentOfferCheckState extends State<PaymentOfferCheck2> {
   final OrdersController ordersController = Get.find<OrdersController>();
  int selectedContainerIndex = -1;
  String _selectedAddress = '';
  String _selectedAddressId = '';

  @override
  void initState() {
    super.initState();
    fetchSelectedAddress();
  }

  void startMyFatoorahPayment() async {
    try {
      var response = await MyFatoorah.startPayment(
        context: context,
        request: MyfatoorahRequest.test(
          currencyIso: Country.SaudiArabia,
          successUrl: 'https://media.istockphoto.com/id/1077567192/ko/%EB%B2%A1%ED%84%B0/%EB%B2%A1%ED%84%B0-%EC%82%AC%EC%8B%A4-%ED%99%95%EC%9D%B8-%ED%91%9C%EC%8B%9C-%EC%95%84%EC%9D%B4%EC%BD%98.jpg?s=170667a&w=0&k=20&c=RCuI9gkfeh3h7JUDZSHlXX7aJrEqOzgXx4-jpqAbstk=',
          errorUrl: 'https://cdn.pixabay.com/photo/2017/02/12/21/29/false-2061131_1280.png',
          invoiceAmount: 100,
          language: ApiLanguage.English,
          token:
              'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',
        ),
      );
      //print(response.paymentId.toString());
    if (response.isSuccess) {
      // Payment successful
      // Call your API here
      try {
        await ordersController.carFormClient(
          carPiece: widget.carPiece,
          carTypeIds: widget.carTypeIds,
          carModelIds: widget.carModelIds,
          chassisNumber: widget.chassisNumber,
          pieceType: widget.pieceType,
          pieceDetail: widget.pieceDetail,
          images: widget.images,
          birthDate: widget.birthDate,
          latitude: widget.latitude,
          longitude: widget.longitude,
          for_government: widget.forGovernment,
        );

        // Navigate to the success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrdersClient(
            
          )),
        );
      } catch (e) {
        
      }
    } else {
      // Payment failed or was cancelled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed or was cancelled')),
      );
    }
  } catch (e) {
    // Handle the payment error here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Error')),
    );
  }
}
  Future<void> fetchSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String address = prefs.getString('selected_address') ?? '';
    String addressId = prefs.getString('selected_address_id') ?? '';

    setState(() {
      _selectedAddress = address;
      _selectedAddressId = addressId;
      if (_selectedAddress.isNotEmpty) {
        selectedContainerIndex = 1;
      }
    });
  }


  void selectContainer(int index) {
    setState(() {
      selectedContainerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchSelectedAddress();
        },
        child: SafeArea(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          _selectedAddress.isNotEmpty
                              ? _selectedAddress
                              : 'Please add an address in your profile first.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: deepPurple,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              CustomSelection1(
                index: 1,
                isSelected: selectedContainerIndex == 1,
                title: "MyFatoorah",
                description: "ST - Building - Floor",
                onTap: () {
                  selectContainer(1);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 310,
                      child: Text(
                        'After clicking " pay now " you will be redirected to Myfatoorah to complete your purchase securely',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                          fontFamily: 'Roboto',
                        ),
                      )),
                ],
              ),
              SizedBox(height: 10),
            
              CustomButton(
                text: 'Pay',
                onPressed: () {
                  if (selectedContainerIndex == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a payment method')),
                    );
                    return;
                  }
                  if (_selectedAddressId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No delivery address selected')),
                    );
                    return;
                  }

                  if (selectedContainerIndex == 1) {
                    // MyFatoorah payment
                    startMyFatoorahPayment();
                  } else {
                    // Handle other payment methods
                    // acceptOffer(widget.offerId, _selectedAddressId,
                    //     selectedContainerIndex);
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



