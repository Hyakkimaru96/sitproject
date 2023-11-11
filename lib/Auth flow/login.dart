import 'package:flutter/material.dart';
import 'package:sit/Auth%20Flow/signup.dart';

import '../Main application/dashboard.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This line will hide the back button
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // a. Static SIT Logo Display on Top
            Container(
              alignment: Alignment.center,
              child: Image.asset('assets/sit_logo.png'), // Replace with actual logo path
            ),
            SizedBox(height: 20.0),

            // c. Login - MPIN
            Text(
              'Login - MPIN (6 Digits Only)',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter MPIN'),
              maxLength: 6,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),

            // Forgot Password Popup Button
            ElevatedButton(
              onPressed: () {
                _showForgotPasswordPopup(context);
              },
              child: Text('Forgot Password'),
            ),

            SizedBox(height: 10.0),

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

            SizedBox(height: 10.0),

            // Navigate to Sign Up Screen
            TextButton(
              onPressed: () {
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
