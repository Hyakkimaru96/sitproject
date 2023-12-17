import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sit/Auth%20Flow/login.dart';
import 'package:sit/Utilities/global.dart';

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
    // Add more cities as needed
  ];

  String fullName = '';
  String emailAddress = '';
  String mobileNo = '';
  String selectedCity = 'Chennai';
  String referredBy = '';
  String personName = '';
  String personMobileNo = '';

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController referredByController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController personMobileNoController = TextEditingController();

  // Create a boolean variable to track whether all required fields are filled
  bool areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to the text controllers for real-time validation
    fullNameController.addListener(updateButtonState);
    emailController.addListener(updateButtonState);
    mobileNoController.addListener(updateButtonState);
    referredByController.addListener(updateButtonState);
    personNameController.addListener(updateButtonState);
    personMobileNoController.addListener(updateButtonState);
  }

  void updateButtonState() {
    // Check if all required fields are filled
    if (fullNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        mobileNoController.text.isNotEmpty &&
        referredByController.text.isNotEmpty &&
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
    // Simulating a 1-second delay for sign-up
    await Future.delayed(Duration(seconds: 1));

    // Construct a JSON object with the collected data
    Map<String, dynamic> jsonData = {
      'fullName': fullName,
      'emailAddress': emailAddress,
      'mobileNo': mobileNo,
      'selectedCity': selectedCity,
      'referredBy': referredBy,
      'personName': personName,
      'personMobileNo': personMobileNo,
    };

    // Convert the JSON object to a JSON string
    String jsonString = json.encode(jsonData);

    // Print the JSON string in the terminal (you would replace this with your API call)
    print('Sending data to server...');
    print('JSON Data: $jsonString');

    // Navigate to the login screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
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
            textFieldPrettier(
                context, fullNameController, 'Full Name'),
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
            textFieldPrettier(context, referredByController, 'Referred By'),
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
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
