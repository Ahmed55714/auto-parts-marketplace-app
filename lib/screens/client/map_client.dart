import 'package:flutter/material.dart';
import 'package:work2/screens/client/registration_form_client.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_search.dart';
import 'car_form.dart';

class ClientMap extends StatelessWidget {
  const ClientMap({super.key});

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
            text: 'Order Now',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarForm(),
                ),
              );
              // RegistrationFormClinet(),),);
            },
          ),
        ],
      ),
    ));
  }
}
