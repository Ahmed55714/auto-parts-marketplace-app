// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:work2/screens/vendor/Bottom_nav.dart';
import 'package:work2/screens/vendor/orders.dart';
import 'package:work2/widgets/custom_button.dart';

import '../../generated/l10n.dart';
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
              Text(
                S.of(context).TrueScreen,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: Text(
                  S.of(context).TrueScreen1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: S.of(context).TrueScreen2,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                  text: S.of(context).TrueScreen3,
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
              Text(
                S.of(context).TrueScreen4,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: Text(
                  S.of(context).TrueScreen5,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: S.of(context).TrueScreen2,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                  text: S.of(context).TrueScreen3,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Directionality(
                            textDirection: TextDirection.ltr,
                            child: const ClientMap()),
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
              Text(
                S.of(context).TrueScreen6,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: Text(
                  S.of(context).TrueScreen7,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: S.of(context).TrueScreen2,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                text: S.of(context).TrueScreen3,
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
              Text(
                S.of(context).TrueScreen6,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: Text(
                  S.of(context).TrueScreen1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: S.of(context).TrueScreen2,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                text: S.of(context).TrueScreen3,
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
              Text(
                S.of(context).Offers13,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: Text(
                  S.of(context).Offers14,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),

              CustomButton(
                text: S.of(context).Offers15,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Directionality(
                          textDirection: TextDirection.ltr, child: MyOrders()),
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
               Text(
                S.of(context).TrueScreen,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child:  Text(
                  S.of(context).TrueScreen1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),
              CustomButton2(
                text: S.of(context).TrueScreen2,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12.0),
              CustomButton(
                  text: S.of(context).Profile,
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
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
                    height:
                        24.0), // Provides space between the icon and the text
                Text(
                  S.of(context).AreCancel30,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8.0), // Provides space between the texts
                Container(
                  width: 300,
                  child: Text(
                    S.of(context).AreCancel31,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                  ),
                ),
                const SizedBox(height: 32.0),

                CustomButton(
                    text: S.of(context).AreCancel32,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdersClient(),
                          // const CarForm(),
                        ),
                      );
                    }),
              ],
            ),
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
              Text(
                S.of(context).Offers13,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: Text(
                  S.of(context).Offers14,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Roboto'),
                ),
              ),
              const SizedBox(height: 32.0),

              CustomButton(
                text: S.of(context).Orders,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdersClient(
                      
                      ),
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
