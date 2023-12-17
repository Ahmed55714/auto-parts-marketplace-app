import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_search.dart';
import 'Registration_form.dart';

class MyMap extends StatelessWidget {
  MyMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Column(
            children: [
              CustomSearchBar(),
              Center(
                child: Text('My Map'),
              ),
            ],
          ),
          CustomButton(
            text: 'My orders',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrationForm(),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
