import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:work2/screens/vendor/Bottom_nav.dart';
import 'package:work2/screens/vendor/orders.dart';
import 'package:work2/widgets/custom_button.dart';

import '../client/account_client.dart';
import '../client/map_client.dart';
import '../client/orders_clint.dart';

class TrueScreen extends StatefulWidget {
  @override
  State<TrueScreen> createState() => _TrueScreenState();
}

class _TrueScreenState extends State<TrueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'We got your request!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'The request is being reviewed and will be responded to as soon as possible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: 'Edit',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                  text: 'Homepage',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyOrders(),

                        // const CarForm(),
                      ),
                    );
                   
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TrueresgesterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'Registration Successfully',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'You Can Do Your First Order',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: 'Edit',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                  text: 'Homepage',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ClientMap(),
                        // const CarForm(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class updateTrueScreen extends StatelessWidget {
  final String name;

  const updateTrueScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'Profile Updated successfully',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32.0),
              CustomButton2(
                text: 'Edit',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                  text: 'Homepage',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountClient(
                          name: name,
                        ),
                        // const CarForm(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TrueOrderClinetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'We got your Order!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'Check your orders to see the status of your order from home page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: 'Edit',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                text: 'Homepage',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientMap(),
                      // const CarForm(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TrueOrderClinetScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'We got your Order!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'Check your orders to see the status of your order from home page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: 'Edit',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                text: 'Homepage',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientMap(),
                      // const CarForm(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrueOfferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'You made an Offer!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'Check your orders to see the status of your order from Order page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),

              CustomButton(
                text: 'Orders',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrders(),
                      // const CarForm(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrueComplinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'We got your request!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'The request is being reviewed and will be responded to as soon as possible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: 'Edit',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                  text: 'Profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountClient(),
                        // const CarForm(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TruePayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'Your order will be shipped and delivered soon!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'The request is being reviewed and will be responded to as soon as possible.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),

              CustomButton(
                  text: 'My Orders',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersClient(),
                        // const CarForm(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TrueReturnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/true.svg',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              const Text(
                'You made an Offer!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: const Text(
                  'Check your orders to see the status of your order from Order page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),

              CustomButton(
                text: 'Orders',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersClient(),
                      // const CarForm(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
