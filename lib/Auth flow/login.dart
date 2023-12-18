import 'package:flutter/material.dart';
import 'package:sit/Auth%20Flow/signup.dart';
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

    // Add listeners to the text controllers for real-time validation
    _masterpinController.addListener(updateButtonState);
  }

  void updateButtonState() {
    // Check if all required fields are filled
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
}
