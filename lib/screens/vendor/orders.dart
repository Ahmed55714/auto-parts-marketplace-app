import 'package:flutter/material.dart';
import 'package:work2/constants/colors.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import 'Bottom_nav.dart';
import 'offer_form.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

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
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'Order 03654',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
              ),

              orderDetails('', ''),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomButton3(text: 'Aceept', onPressed: () {}),
                  ),
                  CustomButton4(text: 'Decline', onPressed: () {}),
                ],
              ),
              const CancelOrderSection(),
              orderDetails('03654', 'Pending'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton5(text: 'Out for delivery', onPressed: () {}),
                ],
              ),
              const CancelOrderSection(),

              // Second Order Details
              orderDetails('03655', 'Accepted'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      text: 'Make an Offer',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfferForm()));
                      }),
                ],
              ),
              const CancelOrderSection(),

              // Third Order Details
              orderDetails('03656', 'Out for delivery'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton5(text: 'Out for delivery', onPressed: () {}),
                ],
              ),
              const CancelOrderSection(),

              // Fourth Order Details
            ],
          ),
        ),
      ),
    );
  }

  Widget orderDetails(String? orderNumber, String? orderStatus) {
    if (orderNumber == null || orderStatus == null) {
      return Container();
    }

    return Padding(
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
            const SizedBox(height: 23),
            const OrderDetailLine(
              title: 'Needed car piece',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Car type',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Car model',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Chassis number',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Piece type',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Piece details',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Date',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Car License',
              placeholder: 'Placeholder',
            ),
            const OrderDetailLine(
              title: 'Near places',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Order Status',
              placeholder: orderStatus!,
              placeholderColor:
                  orderStatus == 'Pending' ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
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
          child: CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              placeholder,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: placeholderColor ?? greyColor,
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
          child: Text(
            'You can’t cancel order before 30 days in case client didn’t respond.',
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Bahij TheSansArabic',
              fontWeight: FontWeight.w300,
              color: greyColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
