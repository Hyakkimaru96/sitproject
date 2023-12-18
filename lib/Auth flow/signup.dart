import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sit/Auth%20Flow/login.dart';
import 'package:sit/Auth%20flow/login.dart';
import 'package:sit/Utilities/global.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<String> citiesInTamilNadu = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Tiruchirappalli',
    'Salem',
    'Tirunelveli',
  ];

  String fullName = '';
  String emailAddress = '';
  String mobileNo = '';
  String selectedCity = 'Chennai';
  String personName = '';
  String personMobileNo = '';

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController personMobileNoController = TextEditingController();

  // Create a boolean variable to track whether all required fields are filled
  bool areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();

    fullNameController.addListener(updateButtonState);
    emailController.addListener(updateButtonState);
    mobileNoController.addListener(updateButtonState);
    personNameController.addListener(updateButtonState);
    personMobileNoController.addListener(updateButtonState);
  }

  void updateButtonState() {
    // Check if all required fields are filled
    if (fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileNoController.text.isNotEmpty &&
        personNameController.text.isNotEmpty &&
        personMobileNoController.text.isNotEmpty) {
      setState(() {
        areAllFieldsFilled = true;
      });
    } else {
      setState(() {
        areAllFieldsFilled = false;
      });
    }
  }

  Future<void> _sendDataToServer() async {
    fullName = fullNameController.text;
    emailAddress = emailController.text;
    mobileNo = mobileNoController.text;
    personName = personNameController.text;
    personMobileNo = personMobileNoController.text;
    Map<String, dynamic> jsonData = {
      'fullName': fullName,
      'emailAddress': emailAddress,
      'mobileNo': mobileNo,
      'selectedCity': selectedCity,
      'personName': personName,
      'personMobileNo': personMobileNo,
    };

    String jsonString = json.encode(jsonData);
    print('Sending data to server...');
    print('JSON Data: $jsonString');
    final response = await http.post(
      Uri.parse(
          'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonString,
    );

    if (response.statusCode == 200) {
      print('Server response: ${response.body}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetMasterpinScreen(),
        ),
      );
    } else {
      print(
          'Failed to send data to the server. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            // a. Static SIT Logo Display on Top
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                  'assets/images/ignition.jpg'), // Replace with actual logo path
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 24, 04),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            textFieldPrettier(context, fullNameController, 'Full Name'),
            textFieldPrettier(context, emailController, 'Email Address'),
            textFieldPrettier(context, mobileNoController, 'Mobile No'),
            // Dropdown for selecting city
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'City'),
                value: selectedCity,
                items: citiesInTamilNadu.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  // Update the selected city
                  setState(() {
                    selectedCity = value!;
                  });
                },
              ),
            ),
            textFieldPrettier(context, personNameController, 'Person Name'),
            textFieldPrettier(
                context, personMobileNoController, 'Person Mobile No'),
            SizedBox(height: 20.0),

            // f. T&C + Contact SIT Web Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('T&C'),
                TextButton(
                  onPressed: () {
                    // Open T&C or Contact SIT Web link
                  },
                  child: Text('Contact SIT Web'),
                ),
              ],
            ),

            SizedBox(height: 20.0),

            // Signup Button
            ElevatedButton(
              onPressed: areAllFieldsFilled
                  ? () {
                      // Call the function to send data to the server
                      _sendDataToServer();
                    }
                  : null, // Disable the button if not all fields are filled
              child: Text('Sign Up'),
            ),

            SizedBox(height: 10.0),

            // Navigate to Login Screen
            TextButton(
              onPressed: () {
                // Simulating a 1-second delay before navigating to the login screen
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SetMasterpinScreen()),
                  );
                });
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}