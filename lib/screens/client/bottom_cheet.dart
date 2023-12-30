import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work2/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

import '../../widgets/custom_textFaild.dart';
import 'Previews_order.dart';

class BottomSheetWidget extends StatefulWidget {
  final int orderId;

  const BottomSheetWidget({Key? key, required this.orderId}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  int _rating = 0;
  final TextEditingController commentController = TextEditingController();

Future<void> rateOrder(int orderId, int stars, String comment) async {
  final Uri apiEndpoint = Uri.parse('https://slfsparepart.com/api/client/orders/$orderId/rate');
  final prefs = await SharedPreferences.getInstance();
  final String? authToken = prefs.getString('auth_token');
  
  try {
    final response = await http.post(
      apiEndpoint,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: {
        'stars': stars.toString(),
        'comment': comment,
      },
    );
    
    if (response.statusCode == 200) {
      print('Rating submitted successfully.');
print('Response body: ${response.body}');
    } else {
      // Handle the error. The server might return a 4xx or 5xx response.
      print('Failed to submit rating: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle any exceptions here
    print('Error occurred while submitting rating: $e');
  }
}
@override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9, // 60% of screen height

      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              SvgPicture.asset('assets/images/true.svg', height: 80.0),
              const SizedBox(height: 10),
              const Text(
                'Your Order has been delivered successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const Text(
                'Please rate your experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: 'Roboto'),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero,
                      ),
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                    iconSize: 40.0,
                  );
                }),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 70,
                child: CustomTextField(
                  fieldHeight: 70,
                  labelText: 'Comment',
                  controller: commentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
              ),
              CustomButton(
                text: 'Done',
                onPressed: () async {
                  if (_rating == 0 || commentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please add a rating and comment'),
                      ),
                    );
                    return;
                  }

                  await rateOrder(widget.orderId, _rating, commentController.text);
                  Navigator.pop(context); // Dismiss bottom sheet after submitting
                  // Optionally, navigate to another page if needed
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
