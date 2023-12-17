import 'package:flutter/material.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/screens/client/orders_clint.dart';
import 'package:work2/widgets/custom_button.dart';

import '../../widgets/custom_continer.dart';
import '../vendor/Bottom_nav.dart';
import 'bottom_cheet.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int selectedContainerIndex = -1;

  void selectContainer(int index) {
    setState(() {
      selectedContainerIndex = (selectedContainerIndex == index) ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        'Delivery Adress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                        ),
                      ),
                      Text(
                        'St-Building-floor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: deepPurple,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: deepPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            CustomSelection1(
              index: 0,
              isSelected: selectedContainerIndex == 0,
              title: "MyFatoorah",
              description: "ST - Building - Floor",
              onTap: () {
                selectContainer(0);
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
              index: 1,
              isSelected: selectedContainerIndex == 1,
              title: "Cash on delivery",
              description: "ST - Building - Floor",
              onTap: () {
                selectContainer(1);
              },
            ),
            CustomButton(text: 'Pay', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersClient()), 
              );
              showModalBottomSheet(
                context: context,
                builder: (context) => BottomSheetWidget(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
