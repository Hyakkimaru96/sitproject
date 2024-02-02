import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sit/Auth%20Flow/signup.dart';
import 'package:http/http.dart' as http;
import 'package:sit/Auth%20flow/verify.dart';
import 'package:sit/Utilities/Database_helper.dart';
import 'package:sit/Utilities/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Main application/dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _loginEmailController = TextEditingController();
  TextEditingController _mpinController = TextEditingController();
  TextEditingController _forgotPasswordEmailController =
      TextEditingController();

  bool areAllLoginFieldsFilled = false;
  bool isForgotPasswordEmailFilled = false;

  @override
  void initState() {
    super.initState();
    _loginEmailController.addListener(updateLoginButtonState);
    _mpinController.addListener(updateLoginButtonState);
    _forgotPasswordEmailController.addListener(updateForgotPasswordButtonState);
  }

  void updateLoginButtonState() {
    if (_loginEmailController.text.isNotEmpty &&
        _mpinController.text.isNotEmpty) {
      setState(() {
        areAllLoginFieldsFilled = true;
      });
    } else {
      setState(() {
        areAllLoginFieldsFilled = false;
      });
    }
  }

  void updateForgotPasswordButtonState() {
    setState(() {
      isForgotPasswordEmailFilled =
          _forgotPasswordEmailController.text.isNotEmpty;
    });
  }

  Future<void> sendLoginCredentials(String email, String mpin) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("Token is " + fcmToken!);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print("Token is " + fcmToken);
    }).onError((err) {
      print("Error is " + err);
    });
    String apiUrl = 'http://188.166.218.202/login';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'email': email, 'mpin': mpin};

    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('is_verified')) {
          bool x = responseBody['is_verified'];
          print(x);
          if (x) {
            Fluttertoast.showToast(
              msg: 'Login Success..',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            bool isVerified = responseBody['is_verified'] == 1;

            await DatabaseHelper.instance.insertUserData(
              email: responseBody['email'],
              name: responseBody['name'],
              phone: responseBody['phone'],
              city: responseBody['city'],
              personName: responseBody['personName'],
              mpin: mpin,
              personPhone: responseBody['personMobileNo'],
              isVerified: isVerified,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationScreen(),
              ),
            );
            bool isVerified = responseBody['is_verified'] == 0;
            await DatabaseHelper.instance.insertUserData(
              email: responseBody['email'],
              name: responseBody['name'],
              phone: responseBody['phone'],
              city: responseBody['city'],
              personName: responseBody['personName'],
              mpin: mpin,
              personPhone: responseBody['personMobileNo'],
              isVerified: isVerified,
            );
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: '${response.body}. Try again',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      Fluttertoast.showToast(
        msg: 'Error during login. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
              child: Image.asset('assets/images/ignition.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 24, 04),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'Email',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                ),
                controller: _loginEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 15.0),
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
                controller: _mpinController,
                maxLength: 6,
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: areAllLoginFieldsFilled
                  ? () async {
                      // Simulating a 1-second delay for login
                      await Future.delayed(Duration(seconds: 1));
                      String email = _loginEmailController.text;
                      String mpin = _mpinController.text;
                      await sendLoginCredentials(email, mpin);
                    }
                  : null, // Disable the button if not all login fields are filled
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
              child: Text("Don't have an account? Sign Up"),
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
              controller: _forgotPasswordEmailController,
              decoration: InputDecoration(labelText: 'Enter Registered Email'),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
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
              onPressed: isForgotPasswordEmailFilled
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        String email = _forgotPasswordEmailController.text;
                        await sendResetEmail(email);
                        Navigator.of(context).pop();
                        _forgotPasswordEmailController.clear();
                      }
                    }
                  : null,
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendResetEmail(String email) async {
    String apiUrl = 'http://188.166.218.202/resetpassmail';
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
      }
    } catch (e) {
      print('Error during HTTP request: $e');
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
                'assets/images/ignition.jpg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 24, 04),
              child: Text(
                "Set Masterpin",
                style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
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
                      await DatabaseHelper.instance.database;
                      List<Map<String, dynamic>> allUserData =
                          await DatabaseHelper.instance.getAllUserData();
                      String email = allUserData.first['email'];
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
    String apiUrl = 'http://188.166.218.202/set_mpin';
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
