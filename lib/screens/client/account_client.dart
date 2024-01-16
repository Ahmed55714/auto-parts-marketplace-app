// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/client/Terms_and_conditions.dart';

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../intro/onboarding_screen.dart';
import 'Complain_client.dart';
import 'Profile_clint.dart';

class AccountClient extends StatefulWidget {
  final String? name;
  const AccountClient({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  State<AccountClient> createState() => _AccountClientState();
}

class _AccountClientState extends State<AccountClient> {
  String? _imageURL;
  String? _name;
  Future<void> fetchProfilePic() async {
    final Uri apiEndpoint = Uri.parse("https://slfsparepart.com/api/user");
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('auth_token');

    try {
      final response = await http.get(
        apiEndpoint,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final imageUrl = userData['image_url'];
        final name = userData['name'];
        setState(() {
          _imageURL = imageUrl;
          _name = name;
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle any exceptions here
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfilePic();
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
      (_) => false, // Remove all routes below the pushed route
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  S.of(context).MyAccount,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple, width: 2),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            _imageURL ?? 'YOUR_DEFAULT_IMAGE_URL_HERE'),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_name ?? S.of(context).Name}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: deepPurple,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _ProfileInfo(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: ProfileClient())),
                              ))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _CustomDivider(),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportClient()),
              ),
              child: _buildOptionRow(
                  'assets/images/clipboard-tick.svg', S.of(context).MyAccount3),
            ),
            const SizedBox(height: 12),
            const _CustomDivider(),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsAndConditions()),
              ),
              child: _buildOptionRow(
                  'assets/images/info-circle.svg', S.of(context).MyAccount4),
            ),
            const SizedBox(height: 12),
            const _CustomDivider(),
            const SizedBox(height: 12),
            GestureDetector(
                onTap: () => signOut(),
                child: _buildOptionRow(
                    'assets/images/login.svg', S.of(context).MyAccount5)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(
    String iconPath,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, height: 24, width: 24),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final VoidCallback onTap;

  const _ProfileInfo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: Text(
              S.of(context).MyAccount2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: greyColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.grey,
      height: 20,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
