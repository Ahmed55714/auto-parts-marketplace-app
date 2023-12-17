import 'package:flutter/material.dart';

import '../constants/colors.dart';




class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: deepPurple,
        minimumSize: const Size(20 * 17, 50),
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: 
           const TextStyle(
            fontSize: 16,
            height: 1.26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
        
        ),
      ),
    );
  }
}





class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton2({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: deepPurple, 
        side: const BorderSide(color: deepPurple, width: 2.0), 
        minimumSize: const Size(20 * 17, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.26,
          fontWeight: FontWeight.w500,
          color: deepPurple, 
         
        ),
      ),
    );
  }
}




class CustomButton3 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton3({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: deepPurple,
        minimumSize: const Size(20 * 8, 50),
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: 
           const TextStyle(
            fontSize: 16,
            height: 1.26,
            fontWeight: FontWeight.w500,
            color: Colors.white,
         
        ),
      ),
    );
  }
}





class CustomButton4 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton4({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: deepPurple, 
        side: const BorderSide(color: deepPurple, width: 2.0), 
        minimumSize: const Size(20 * 8, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.26,
          fontWeight: FontWeight.w500,
          color: deepPurple, 
       
        ),
      ),
    );
  }
}


class CustomButton5 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton5({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: deepPurple, 
        side: const BorderSide(color: greyColor, width: 2.0), 
        minimumSize: const Size(20 * 17, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.26,
          fontWeight: FontWeight.w500,
          color: greyColor, 
          
        ),
      ),
    );
  }
}


class CustomButtongrey extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButtongrey({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 16,right:16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: greyColor, 
          side: const BorderSide(color: greyColor, width: 2.0), 
          minimumSize: const Size(20 * 17, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.26,
                fontWeight: FontWeight.w500,
                color: greyColor, 
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// class StepProgressButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   const StepProgressButton({Key? key, required this.text, required this.onPressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: deepPurple,
//         minimumSize: const Size(20 * 15, 50),
//                 shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: Text(
//         text,
//         style: 
//            const TextStyle(
//             fontSize: 18,
//             height: 1.26,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
          
//         ),
//       ),
//     );
//   }
// }

// class TitleWidget extends StatelessWidget {
//   final String text;
//   final String secondtext;

//   const TitleWidget({super.key, required this.text, required this.secondtext});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 23,
//             fontWeight: FontWeight.w700,
//             color: deepPurple,
//           ),
//         ),
//          Text(
//           secondtext,
//           style: const TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w400,
//             color: deepPurple
//           ),
//         ),
//       ],
//     );
//   }
// }