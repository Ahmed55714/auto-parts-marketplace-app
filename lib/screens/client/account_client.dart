import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/screens/client/Terms_and_conditions.dart';
import '../../constants/colors.dart';
import 'Complain_client.dart';
import 'Profile_clint.dart';


class AccountClient extends StatefulWidget {
  const AccountClient({super.key});

  @override
  State<AccountClient> createState() => _AccountClientState();
}

class _AccountClientState extends State<AccountClient> {
    String? _profileImageUrl;
  String? _profileName;

   @override
  void initState() {
    super.initState();
    _loadProfileInfo();
  }

  void _loadProfileInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImageUrl = prefs.getString('profile_image_url');
      _profileName = prefs.getString('profile_name');
    });
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
                  const _ProfileIcon(),
                  const SizedBox(width: 10),
                  _ProfileInfo(
                      onTap: () =>   Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileClient()),))
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _CustomDivider(),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsAndConditions()),),
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

  Widget _buildOptionRow(String iconPath, String text,) {
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

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue, // Example color
      // You can add an image or icon inside the CircleAvatar if needed
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
