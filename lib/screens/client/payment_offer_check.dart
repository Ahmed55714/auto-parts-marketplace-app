import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_continer.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';

class PaymentOfferCheck extends StatefulWidget {
  final int offerId;

  const PaymentOfferCheck({Key? key, required this.offerId}) : super(key: key);

  @override
  State<PaymentOfferCheck> createState() => _PaymentOfferCheckState();
}

class _PaymentOfferCheckState extends State<PaymentOfferCheck> {
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
          successUrl: 'https://www.facebook.com',
          errorUrl: 'https://www.google.com/',
          invoiceAmount: 100,
          language: ApiLanguage.English,
          token:
              'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',
        ),
      );
      //print(response.paymentId.toString());
      if (response.isSuccess) {
        // Call acceptOffer on successful payment
        acceptOffer(widget.offerId, _selectedAddressId, selectedContainerIndex);
      } else {
        // Stay on the same page or show an error message
        //print('Payment failed or was cancelled');
      }
    } catch (e) {
      // Handle the payment error here
      //print('Payment Error: $e');
      // Optionally, show an error message or stay on the same page
    } catch (e) {
      //print('Payment Error: $e');
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

  Future<void> acceptOffer(
      int offerId, String addressId, int paymentMethodIndex) async {
    String paymentMethodId = paymentMethodIndex.toString();
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/client/orders/offers/$offerId/accept");
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
          'address_id': addressId,
          'payment_method_id': paymentMethodId,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Offer accepted successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TruePayment()),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept offer')),
        );
      }
    } catch (e) {
      // Handle any exceptions here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while accepting offer: $e')),
      );
    }
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
              CustomSelection1(
                index: 2,
                isSelected: selectedContainerIndex == 2,
                title: "Cash on delivery",
                description: "ST - Building - Floor",
                onTap: () {
                  selectContainer(2);
                },
              ),
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
                    acceptOffer(widget.offerId, _selectedAddressId,
                        selectedContainerIndex);
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
