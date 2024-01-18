import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import 'Bottom_nav.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             
            children: [
              const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BackButtonDeep(),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).AreCancel48,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  orderDetails(context),
                   SizedBox(height: 10),
                  orderDetails3(context),
                  SizedBox(height: 10),
                  orderDetails2(context),
                 
            ],
          ),
        ),
      )
    );
  }
   Widget orderDetails(BuildContext context) {
 
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 46, 238).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.deepPurple, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).AreCancel49,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
                SizedBox(height: 28),
                Text("120 \$", 
                
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),

              ],
            ),
          ),
        ),
      
      ],
    );
  }
  Widget orderDetails2(BuildContext context) {
 
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 46, 238).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.deepPurple, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    S.of(context).AreCancel51,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: deepPurple,
                    ),
                  ),
                
                SizedBox(height: 28),
                Text("120 \$",
                
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),

              ],
            ),
          ),
        ),
      
      ],
    );
  }
  Widget orderDetails3(BuildContext context) {
 
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 46, 238).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.deepPurple, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                Text(
                  S.of(context).AreCancel50,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),
                SizedBox(height: 28),
                Text("120 \$",
                
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: deepPurple,
                  ),
                ),

              ],
            ),
          ),
        ),
      
      ],
    );
  }
}

