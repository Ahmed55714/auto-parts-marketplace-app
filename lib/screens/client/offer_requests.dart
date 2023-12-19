import 'package:flutter/material.dart';
import 'package:work2/screens/client/report_client.dart';
import 'package:work2/widgets/custom_button.dart';
import '../../constants/colors.dart'; // Ensure this file exists and contains deepPurple color
import '../vendor/Bottom_nav.dart'; // Ensure this file and BottomNav widget exist

class OfferRequests extends StatefulWidget {
  const OfferRequests({Key? key}) : super(key: key);

  @override
  _OfferRequestsState createState() => _OfferRequestsState();
}

class _OfferRequestsState extends State<OfferRequests> {
  final List<String> items = [
    "Home",
    "Explore",
    "Search",
    "Feed",
    "Posts",
    "Activity",
    "Setting",
    "Profile",
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
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Offer Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors
                        .deepPurple, // Assuming deepPurple is a defined color
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
                      color: Colors
                          .deepPurple, // Assuming deepPurple is a defined color
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
                                  width: 110,
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
                                    child: Column(
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
                    Expanded(child: MyList()),
                    // SizedBox(height: 8),
                    // CustomButton(
                    //     text: 'Save Pdf',
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => ReportClient()));
                    //     }),
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

class MyList extends StatelessWidget {
  final List<Map<String, String>> carPieces = List.generate(
    10,
    (index) => {
      'title': 'Needed car piece',
      'subtitle': 'Placeholder',
    },
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: carPieces.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              carPieces[index]['title'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              carPieces[index]['subtitle'] ?? '',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
          ),
        );
      },
    );
  }
}
