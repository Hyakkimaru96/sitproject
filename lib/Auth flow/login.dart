import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sit/Auth%20Flow/signup.dart';
import 'package:http/http.dart' as http;
import 'package:sit/Utilities/Database_helper.dart';
import '../Main application/dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _forgotpasswordController = TextEditingController();

  // Create a boolean variable to track whether all required fields are filled
  bool areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to the text controllers for real-time validation
    _emailController.addListener(updateButtonState);
  }

  void updateButtonState() {
    // Check if all required fields are filled
    if (_emailController.text.isNotEmpty) {
      setState(() {
        areAllFieldsFilled = true;
      });
    } else {
      setState(() {
        areAllFieldsFilled = false;
      });
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
            SizedBox(
              height: 20.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                  'assets/images/ignition.jpg'), // Replace with actual logo path
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 24, 04),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'MPIN (6 Digits Only)',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter MPIN',
                ),
                controller: _emailController,
                maxLength: 6,
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: areAllFieldsFilled
                  ? () async {
                      // Simulating a 1-second delay for login
                      await Future.delayed(Duration(seconds: 1));

                      // Simulating a successful login
                      // Replace this with your actual authentication logic
                      bool isAuthenticated = true;

                      if (isAuthenticated) {
                        // Navigate to the dashboard screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ),
                        );
                      } else {
                        // Handle failed authentication
                        // You can show an error message or perform other actions
                      }
                    }
                  : null, // Disable the button if not all fields are filled
              child: Text('Login'),
            ),
            SizedBox(height: 20.0),
            InkWell(
              onTap: () {
                _showForgotPasswordPopup(context);
              },
              child: Text('Forgot Password'),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                // Simulating a 1-second delay before navigating to the sign-up screen
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                });
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _forgotpasswordController,
              decoration: InputDecoration(labelText: 'Enter Registered Email'),
              validator: (value) {
                if (value!.isEmpty || !value!.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String email = _forgotpasswordController.text;
                  await sendResetEmail(email);
                  Navigator.of(context).pop();
                  _forgotpasswordController.clear();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendResetEmail(String email) async {
    String apiUrl =
        'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/resetpassmail';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'email': email};

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print(
            'Reset email sent successfully. Backend response: ${response.body}');
      } else {
        print(
            'Error sending reset email: ${response.statusCode}, ${response.body}');
        // Handle error (e.g., show an error message to the user)
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      // Handle error (e.g., show an error message to the user)
    }
  }
}

class SetMasterpinScreen extends StatefulWidget {
  @override
  _SetMasterpinScreenState createState() => _SetMasterpinScreenState();
}

class _SetMasterpinScreenState extends State<SetMasterpinScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _masterpinController = TextEditingController();

  // Create a boolean variable to track whether all required fields are filled
  bool areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    _masterpinController.addListener(updateButtonState);
  }

  void updateButtonState() {
    if (_masterpinController.text.isNotEmpty) {
      setState(() {
        areAllFieldsFilled = true;
      });
    } else {
      setState(() {
        areAllFieldsFilled = false;
      });
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
            SizedBox(
              height: 20.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                  'assets/images/ignition.jpg'), // Replace with actual logo path
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 24, 04),
              child: Text(
                "Set Masterpin",
                style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              'MPIN (6 Digits Only)',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter MPIN',
                  ),
                  controller: _masterpinController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty || value.length != 6) {
                      return 'Please enter a valid 6-digit MPIN';
                    }
                    return null;
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: areAllFieldsFilled
                  ? () async {
                      // Simulating a 1-second delay for setting masterpin
                      await Future.delayed(Duration(seconds: 1));

                      // Simulating a successful masterpin setting
                      // Replace this with your actual logic for setting masterpin

                      // After setting masterpin, navigate to the dashboard screen
                      String email =
                          await getEmailFromLocal(); // Replace with your logic to get email from local
                      String mpin = _masterpinController.text;
                      await postMasterpin(email, mpin);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ),
                      );
                    }
                  : null, // Disable the button if not all fields are filled
              child: Text('Set Masterpin'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> postMasterpin(String email, String mpin) async {
    String apiUrl =
        'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/set_mpin'; // Replace with your actual API URL
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'email': email, 'mpin': mpin};

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Masterpin set successfully. Backend response: ${response.body}');
        await DatabaseHelper.instance.updatemPin(email, mpin);
      } else {
        print(
            'Error setting masterpin: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }

  Future<String> getEmailFromLocal() async {
    String email = '';
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();

    for (var userData in allUserData) {
      email = userData['email'] ?? '';
    }

    return email;
  }
}
