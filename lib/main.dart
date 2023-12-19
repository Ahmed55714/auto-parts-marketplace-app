// ignore_for_file: equal_keys_in_map
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/client/report_client.dart';

import 'screens/client/Bottom_nav.dart';
import 'screens/client/car_form.dart';
import 'screens/client/map_client.dart';
import 'screens/intro/onboarding_screen.dart';
import 'screens/intro/sign_in.dart';
import 'screens/intro/sign_up.dart';
import 'screens/intro/verification.dart';
import 'screens/vendor/Bottom_nav.dart';
import 'screens/vendor/Registration_form.dart';
import 'screens/vendor/Report.dart';

import 'screens/vendor/my_account.dart';
import 'screens/vendor/offer_form.dart';
import 'screens/vendor/orders_rate.dart';

import 'screens/vendor/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));

  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

class MyApp extends StatefulWidget {
  final User? user;
  const MyApp({
    super.key,required this.user,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    String initialRoute = widget.user != null ? '/signup' : '/';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        fontFamily: 'BakbakOne',
        //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const OnboardingScreen(),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        final routes = <String, WidgetBuilder>{
          '/': (context) => const OnboardingScreen(),
          '/signin': (context) => SignIn(),
          '/verification': (context) => VerificationScreen(
                verificationId: settings.arguments as String,
                value: settings.arguments as String,
              ),
          '/signup': (context) => SignUp(),
          '/clientmap': (context) => const ClientMap(),
          '/vendormap': (context) => const VendorMap(),
          '/RegisterationForm': (context) => const RegistrationForm(),
          '/offerform': (context) => const OfferForm(),
          '/ordersrate': (context) => const MyOrders_rate(),
          '/reprt': (context) => const Report(),
          '/myaccount': (context) => const MyAccount(),
          '/profile': (context) => const MyProfile(),
          '/CarForm': (context) => const CarForm(),
          '/clientmap': (context) => const ClintNavBar(),
          '/Report': (context) => const ReportClient(),
        };
        final builder = routes[settings.name];
        if (builder == null) {
          return MaterialPageRoute(
              builder: (ctx) =>
                  const Scaffold(body: Center(child: Text("Page not found"))));
        }
        return MaterialPageRoute(builder: (context) => builder(context));
      },
      builder: (BuildContext context, Widget? child) {
        // Use DefaultTextStyle widget to set the default font
        return DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'BahijTheSansArabic',
          ),
          child: child!,
        );
      },
    );
  }
}
