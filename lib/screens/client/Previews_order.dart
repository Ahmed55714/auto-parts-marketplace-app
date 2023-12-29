import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';
import '../vendor/Bottom_nav.dart';
import '../vendor/offer_form.dart';
import 'offer_client.dart';
import 'offer_requests.dart';
import 'order_repo.dart';

class PreviewsOrder extends StatelessWidget {
  const PreviewsOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButtonDeep(),
                  ],
                ),
              ),
              const Center(
                child: Text(
                  'Previews Orders',
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => OfferClient()));
                    },
                    svgIconPath:
                        'assets/images/+.svg', // Replace with the actual path to your SVG file
                  ),
                ],
              ),

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

              orderDetails('', 'Delevered'),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Return order',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderRepo(),
                          // const CarForm(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              orderDetails('03654', 'Delevered'),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Return order',
                    onPressed: () {},
                  ),
                ],
              ),

              // Second Order Details
              orderDetails('03655', 'Delevered'),

              // Third Order Details

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Return order',
                    onPressed: () {},
                  ),
                ],
              ),

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
