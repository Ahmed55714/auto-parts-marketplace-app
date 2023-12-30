import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/screens/client/orders_clint.dart';
import 'package:work2/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_continer.dart';
import '../intro/custom_true.dart';
import '../vendor/Bottom_nav.dart';
import 'bottom_cheet.dart';

class Payment extends StatefulWidget {
  final int offerId;

  const Payment({Key? key, required this.offerId}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int selectedContainerIndex = -1;
  String _selectedAddress = '';
  String _selectedAddressId = '';

  @override
  void initState() {
    super.initState();
    fetchSelectedAddress();
  }

  Future<void> fetchSelectedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String address = prefs.getString('selected_address') ?? '';
    String addressId =
        prefs.getString('selected_address_id') ?? ''; // Retrieve the address ID

    setState(() {
      _selectedAddress = address;
      _selectedAddressId = addressId;
      if (_selectedAddress.isNotEmpty) {
        selectedContainerIndex = 1; // Default selection, adjust as needed
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
        print('Response body: ${response.body}');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  TruePayment()),
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
                    acceptOffer(widget.offerId, _selectedAddressId,
                        selectedContainerIndex);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
