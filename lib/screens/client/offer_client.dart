import 'package:flutter/material.dart';
import 'package:work2/screens/client/payment.dart';

import '../../constants/colors.dart';
import '../../widgets/custom_button.dart';
import '../vendor/Bottom_nav.dart';
import 'vedor_profile.dart';

class OfferClient extends StatefulWidget {
  const OfferClient({Key? key}) : super(key: key);

  @override
  _OfferRequestsState createState() => _OfferRequestsState();
}

class _OfferRequestsState extends State<OfferClient> {
  final List<String> items = [
    "Nearest to you",
    "Best rated",
    "Highest Prices",
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.explore,
    Icons.search,
    Icons.feed,
    Icons.post_add,
    Icons.local_activity,
    Icons.settings,
    Icons.person,
  ];

  int current = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Offer Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    current = index;
                                  });
                                  pageController.animateToPage(
                                    current,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.ease,
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.all(5),
                                  width: 125,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: current == index
                                        ? deepred
                                        : Colors.white54,
                                    borderRadius: current == index
                                        ? BorderRadius.circular(30)
                                        : BorderRadius.circular(30),
                                    border: current == index
                                        ? Border.all(
                                            color: Colors.red, width: 1.5)
                                        : null,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          items[index],
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            color: current == index
                                                ? Colors.red
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                        if (index == items.length - 1)
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: current == index
                                                ? Colors.red
                                                : Colors.grey.shade400,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VenforProfile(), 
                        ),
                      );
                      
                      },
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'url_to_the_image'), 
                                    radius: 40.0, 
                                  ),
                                  SizedBox(
                                      height:
                                          4.0), // Space between the avatar and the text
                                  Text('Ahmed Said', // The text under the avatar
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                              SizedBox(
                                  width:
                                      10.0), // Spacing between the avatar column and the text column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                     Row(
                                      children: [
                                        Text('Needed car piece ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,fontSize: 16, color: deepPurple )),
                                      
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Car type ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text('Placeholder ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto')),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Piece type ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text('Placeholder ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto')),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Piece details ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text('Placeholder ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto')),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Near places ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text('Placeholder ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto')),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Price ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text('Placeholder ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto')),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Address ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Text('Placeholder ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Roboto')),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.star, color: Colors.yellow),
                                        Icon(Icons.star, color: Colors.yellow),
                                        Icon(Icons.star, color: Colors.yellow),
                                        Icon(Icons.star, color: Colors.yellow),
                                        Icon(Icons.star_border),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), SizedBox(height: 10),
                     Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomButton3(text: 'Aceept', onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Payment(),
                        ),
                      );
                    }),
                  ),
                  CustomButton4(text: 'Decline', onPressed: () {}),
                ],
              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


