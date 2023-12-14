import 'package:flutter/material.dart';
import 'package:sit/Auth%20Flow/signup.dart';

import '../Main application/dashboard.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

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

            // // a. Static SIT Logo Display on Top
            // Container(
            //   alignment: Alignment.center,
            //   child: Image.asset('assets/sit_logo.png'), // Replace with actual logo path
            // ),
            // SizedBox(height: 20.0),

            // c. Login - MPIN
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

            // Login Button
            ElevatedButton(
              onPressed: () async {
                // Simulating a 1-second delay for login
                await Future.delayed(Duration(seconds: 1));

                // Simulating a successful login
                // Replace this with your actual authentication logic
                bool isAuthenticated = true;

                if (isAuthenticated) {
                  // Navigate to the dashboard screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                } else {
                  // Handle failed authentication
                  // You can show an error message or perform other actions
                }
              },
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
            // Navigate to Sign Up Screen
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
              controller: _emailController,
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle forgot password logic (e.g., sending reset email)
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
