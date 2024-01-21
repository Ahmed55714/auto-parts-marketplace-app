// ignore_for_file: equal_keys_in_map
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/getx/regestration.dart';
import 'package:work2/getx/update_profile.dart';

import 'package:work2/screens/client/Complain_client.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart' as flc;
import 'generated/l10n.dart';
import 'getx/auth.dart';

import 'getx/orders.dart';
import 'screens/client/Bottom_nav.dart';
import 'screens/client/car_form.dart';
import 'screens/client/map_client.dart';
import 'screens/intro/custom_true.dart';
import 'screens/intro/onboarding_screen.dart';
import 'screens/intro/sign_in.dart';
import 'screens/intro/sign_up.dart';
import 'screens/intro/verification.dart';
import 'screens/vendor/Bottom_nav.dart';
import 'screens/vendor/Registration_form.dart';
import 'screens/vendor/Report.dart';
import 'screens/vendor/chat/screens/mobile_layout_screen.dart';
import 'screens/vendor/offer_form.dart';
import 'screens/vendor/orders_rate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialization(null);
  HttpOverrides.global = MyHttpOverrides();
  Get.put(AuthController());
  Get.put(RegesterController());
  Get.put(UpdateProfileController());
  Get.put(OrdersController());
  Get.put(LocaleController());

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final userType = prefs.getString('user_type');

  String initialRoute = '/';

  if (token != null) {
    if (userType == 'client') {
      initialRoute = '/clientmapNav';
    } else if (userType == 'vendor') {
      initialRoute = '/vendormapNav';
    } else {
      initialRoute = '/signup';
    }
  }

  runApp(MyApp(initialRoute: initialRoute));

  // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

Future initialization(BuildContext? context) async {
  // Load resources
  await Future.delayed(const Duration(seconds: 3));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        CountryLocalizations.delegate,
      ],

      supportedLocales:
          flc.CountryLocalizations.supportedLocales.map(Locale.new),

      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        fontFamily: 'BakbakOne',
        //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const OnboardingScreen(),
      initialRoute: widget.initialRoute,

      onGenerateRoute: (settings) {
        final routes = <String, WidgetBuilder>{
          '/': (context) => const OnboardingScreen(),
          '/signin': (context) => SignIn(),
          '/verification': (context) => VerificationScreen(
                verificationId: settings.arguments as String,
                phoneNumber: settings.arguments as String,
              ),
          '/signup': (context) => SignUp(),
          '/cclientmap': (context) => const ClientMap(),
          '/vendormapNav': (context) => VendorMap(),
          '/clientmapNav': (context) => const ClintNavBar(),
          '/RegisterationForm': (context) => const RegistrationForm(),
          '/offerform': (context) => OfferForm(
                orderId: settings.arguments as String,
              ),
          '/ordersrate': (context) => const MyOrders_rate(),
          '/reprt': (context) => const Report(),
          
          '/CarForm': (context) => const CarForm(),
          '/Report': (context) => const ReportClient(),
          '/TrueOfferScreen': (context) => TrueOfferScreen(),
          '/chat': (context) => const MobileLayoutScreen(),
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
