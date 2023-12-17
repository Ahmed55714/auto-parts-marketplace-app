import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:work2/widgets/custom_button.dart';

import '../client/map_client.dart';

class TrueScreen extends StatelessWidget {
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
             SvgPicture.asset('assets/images/true.svg', height: 100,width: 100,),
              SizedBox(
                  height: 24.0), // Provides space between the icon and the text
              Text(
                'We got your feed back!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.0), // Provides space between the texts
              Container(
                width: 300,
                child: Text(
                  'adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam',
                  textAlign: TextAlign.center,
                  
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto'
                  ),
                ),
              ),
              SizedBox(
                  height:
                      32.0), 
                       CustomButton2(
              text: 'Edit',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
                  height:
                      12.0),
             CustomButton(text: 'Homepage', onPressed: () {

                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClientMap(),
                // const CarForm(),
              ),
            );
             }
             
             
             ),
             
             
            ],
          ),
        ),
      ),
    );
  }
}
