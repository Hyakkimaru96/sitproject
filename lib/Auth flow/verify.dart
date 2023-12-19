import 'package:flutter/material.dart';
import 'package:sit/Main%20Application/dashboard.dart';
import 'package:sit/Utilities/Database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen();

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isVerified = false;
  bool _isEmailSent = true;
  @override
  void initState() {
    super.initState();
    // Start the timer when the screen is created
    _startTimer();
  }

  // Timer to periodically check the verification status
  void _startTimer() {
    const duration = Duration(seconds: 2);
    Timer.periodic(duration, (timer) async {
      if (!_isVerified) {
        await _checkVerificationStatus();
      } else {
        // Stop the timer if verification is true
        timer.cancel();
      }
    });
  }

  // Function to check the verification status
  Future<void> _checkVerificationStatus() async {
    // Assuming you have the logic to fetch the verification status from the API
    // Modify the following code according to your API response handling
    try {
      int userDataCount = 0;
      int? count = await DatabaseHelper.instance.getUserDataCount();
      setState(() {
        userDataCount = count ?? 0;
      });
      if (userDataCount == 1) {
        await DatabaseHelper.instance.database;
        List<Map<String, dynamic>> allUserData =
            await DatabaseHelper.instance.getAllUserData();
        for (var userData in allUserData) {
          String email = userData['email'];
          Map<String, String> headers = {'Content-Type': 'application/json'};
          Map<String, dynamic> body = {'email': email};
          http.Response response = await http.post(
            Uri.parse(
                'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/check_verified'),
            headers: headers,
            body: jsonEncode(body),
          );

          if (response.statusCode == 200) {
            dynamic responseData = jsonDecode(response.body);

            if (responseData is bool) {
              setState(() {
                _isVerified = responseData;
              });
              if (_isVerified) {
                await DatabaseHelper.instance
                    .updateIsVerifiedStatus(email, _isVerified);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              }
            } else {
              print(
                  'Error checking verification status: ${response.statusCode}');
            }
          }
        }
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Verification'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isEmailSent)
                Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: Text(
                    'Please check the link sent your Email ID',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper.instance.database;
                  List<Map<String, dynamic>> allUserData =
                      await DatabaseHelper.instance.getAllUserData();
                  for (var userData in allUserData) {
                    String email = userData['email'];
                    String name = userData['name'];
                    String apiUrl =
                        'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/resend_email';
                    Map<String, String> headers = {
                      'Content-Type': 'application/json'
                    };
                    Map<String, dynamic> body = {'email': email, 'name': name};
                    try {
                      http.Response response = await http.post(
                        Uri.parse(apiUrl),
                        headers: headers,
                        body: jsonEncode(body),
                      );

                      if (response.statusCode == 200) {
                        print('Backend response: ${response.body}');
                      } else {
                        print(
                            'Backend error: ${response.statusCode}, ${response.body}');
                      }
                    } catch (e) {
                      print('Error during HTTP request: $e');
                    }
                  }
                },
                child: Text('Resend Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
