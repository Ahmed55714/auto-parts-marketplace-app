import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/client/Terms_and_conditions.dart';
import '../../constants/colors.dart';
import 'Complain_client.dart';
import 'Profile_clint.dart';
import 'package:http/http.dart' as http;

class AccountClient extends StatefulWidget {
  const AccountClient({super.key});

  @override
  State<AccountClient> createState() => _AccountClientState();
}

class _AccountClientState extends State<AccountClient> {
  String? _imageURL;
  Future<void> fetchProfilePic() async {
    final Uri apiEndpoint = Uri.parse(
        "https://slfsparepart.com/api/user"); // Replace with your API endpoint
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
        setState(() {
          _imageURL = imageUrl; // Store the image URL in a variable.
        });
      } else {
        // Handle error
        print('Failed to fetch user data');
        print(response.body);
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error occurred while fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfilePic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'My account',
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
                        image: NetworkImage(_imageURL ??
                            'YOUR_DEFAULT_IMAGE_URL_HERE'), // Use the image URL here, or provide a default URL.
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ProfileInfo(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileClient()),
                          ))
                ],
              ),
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
                  'assets/images/clipboard-tick.svg', 'Previews Orders'),
            ),
            const SizedBox(height: 12),
            const _CustomDivider(),
            const SizedBox(height: 12),
            _buildOptionRow(
                'assets/images/info-circle.svg', 'Terms and conditions'),
            const SizedBox(height: 12),
            const _CustomDivider(),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportClient()),
              ),
              child: _buildOptionRow(
                  'assets/images/info-circle.svg', 'Add Complain'),
            ),
            const SizedBox(height: 12),
            const _CustomDivider(),
            const SizedBox(height: 12),
            _buildOptionRow('assets/images/login.svg', 'Log out'),
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
        const Text(
          'Ahmed Khaled',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: deepPurple,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.only(right: 30),
            child: Text(
              'Edit your profile',
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
