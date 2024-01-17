import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../vendor/Bottom_nav.dart';
import 'package:http/http.dart' as http;

class TermsAndConditions extends StatelessWidget {
  Future<Map<String, String>> fetchTermsAndConditions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('https://slfsparepart.com/api/pages'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          'name': data[0]['name'],
          'content': data[0]['content'],
        };
      } else {
        throw Exception('Failed to load terms and conditions');
      }
    } catch (error) {
      throw Exception('Failed to fetch terms and conditions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BackButtonDeep(),
                    ],
                  ),
                ),
                Text(
                  S.of(context).Terms,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<Map<String, String>>(
                  future: fetchTermsAndConditions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final terms = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${terms['name']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              '${terms['content']}',
                              style:
                                  TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
