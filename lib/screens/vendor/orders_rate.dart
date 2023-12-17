import 'package:flutter/material.dart';
import 'package:work2/constants/colors.dart';
import 'package:work2/screens/vendor/Bottom_nav.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textFaild.dart';



class MyOrders_rate extends StatelessWidget {
  const MyOrders_rate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      
                      Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'BahijTheSansArabic',
                          color: deepPurple,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Order 03654',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'BahijTheSansArabic',
                        color: deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              const OrderDetail(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Report',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/reprt');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetail extends StatelessWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.deepPurple, width: 2),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderDetailLine(
              title: 'Needed car piece',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Car type',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Car model',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Chassis number',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Piece type',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Piece details',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Date',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Car License',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Near places',
              placeholder: 'Placeholder',
            ),
            OrderDetailLine(
              title: 'Order Status',
              placeholder: 'Pending',
              placeholderColor: Colors.red,
            ),
            OrderDetailLine(
              title: 'Rate',
              placeholder: '*****',
            ),
            OrderDetailLine(
                title: 'Review',
                placeholder:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.')
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
          flex: 2,
          child: CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: placeholderColor?? Colors.black,
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              placeholder,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontFamily: 'BahijTheSansArabic',
                color: placeholderColor ?? greyColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OrderDetailMultiline extends StatelessWidget {
  final String title;
  final String content;
  final Color? color;

  const OrderDetailMultiline({
    Key? key,
    required this.title,
    required this.content, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black,
        ),
        const SizedBox(height: 7),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontFamily: 'BahijTheSansArabic',
            color: greyColor,
          ),
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}
