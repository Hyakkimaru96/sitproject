import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sit/Auth%20Flow/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sit/Main%20Application/dashboard.dart';
import 'package:sit/Utilities/Database_helper.dart';
import 'package:sit/Auth%20flow/verify.dart';
import 'package:sit/Utilities/global.dart';
import 'package:sit/Utilities/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int userDataCount = 0;
  int _completedSpins = 0;
  int _desiredSpins = 5;
  double _startingSize = 0.25;
  double _endingSize = 0.50;

  Future<void> getUserDataCount() async {
    try {
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
          String mpin = userData['mpin'];
          String apiUrl = 'http://188.166.218.202/check_verified';
          Map<String, String> headers = {'Content-Type': 'application/json'};
          Map<String, dynamic> body = {'email': email};
          try {
            http.Response response = await http.post(
              Uri.parse(apiUrl),
              headers: headers,
              body: jsonEncode(body),
            );

            if (response.statusCode == 200) {
              print('Backend response: ${response.body}');
              Map<String, dynamic> jsonResponse = json.decode(response.body);
              bool isVerified = jsonResponse['is_verified'];
              bool adminApproved = jsonResponse['admin_approved'];
              print(isVerified);
              print(adminApproved);
              await DatabaseHelper.instance
                  .updateIsVerifiedStatus(email, isVerified, adminApproved);
              if (mpin != "0000") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              } else if (mpin == "0000" && isVerified == 'true') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SetMasterpinScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VerificationScreen()),
                );
              }
            } else {
              print('Backend error: ${response.statusCode}, ${response.body}');
            }
          } catch (e) {
            print('Error during HTTP request: $e');
          }
        }
      } else if (userDataCount == 0) {
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        });
      } else {
        Fluttertoast.showToast(
          msg:
              'Multiple Users found!! You are not allowed to proceed further.. Please Clear the data and restart the application',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        Timer(Duration(seconds: 3), () {
          // Exit the app
          SystemNavigator.pop();
        });
      }
    } catch (error) {
      print('Error fetching user data count: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDataCount();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _completedSpins++;
          if (_completedSpins >= _desiredSpins) {
            _controller.stop();
            Timer(Duration(seconds: 2), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            });
          } else {
            _controller.reset();
            _startingSize = _endingSize;
            _endingSize += 0.25;
            _controller.forward();
          }
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double scaleFactor = _startingSize +
                (_endingSize - _startingSize) * _controller.value;
            return Transform.scale(
              scale: scaleFactor,
              child: RotationTransition(
                turns: _controller,
                child: Image(
                  image: AssetImage('assets/images/ignition.jpg'),
                  width: 200,
                  height: 200,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<String> majorCitiesInIndia = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Ahmedabad',
    'Pune',
    'Surat',
    'Jaipur',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
    'Ghaziabad',
    'Ludhiana',
    'Agra',
    'Nashik',
    'Ranchi',
    'Faridabad',
    'Meerut',
    'Rajkot',
    'Kalyan-Dombivali',
    'Vasai-Virar',
    'Varanasi',
    'Srinagar',
    'Aurangabad',
    'Dhanbad',
    'Amritsar',
    'Navi Mumbai',
    'Allahabad',
    'Ranchi',
    'Howrah',
    'Coimbatore',
    'Jabalpur',
    'Gwalior',
    'Vijayawada',
    'Jodhpur',
    'Madurai',
    'Raipur',
    'Kota',
    'Guwahati',
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

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Creating User..."),
            ],
          ),
        );
      },
    );
  }

  // Define a method to hide the loading dialog
  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(),
      ),
    );
  }

  void updateButtonState() {
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
    _showLoadingDialog(context);
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
      'mpin': '0000',
      'fcmtoken': fcmToken,
    };

    String jsonString = json.encode(jsonData);
    print('Sending data to server...');
    print('JSON Data: $jsonString');
    final response = await http.post(
      Uri.parse('http://188.166.218.202/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonString,
    );

    if (response.statusCode == 200 &&
        response.body == "Successfully Registered And mail sent!!!") {
      bool _isVerified = false;
      bool _adminApproved = false;
      try {
        int rowId = await DatabaseHelper.instance.insertUserData(
            email: emailAddress,
            name: fullName,
            phone: mobileNo,
            city: selectedCity,
            personName: personName,
            personPhone: personMobileNo,
            mpin: '0000',
            isVerified: _isVerified,
            profile_pic: 'default_profile_image.jpg',
            admin_approved: _adminApproved);
        print('Data inserted with row id: $rowId');
      } catch (error) {
        print('Error inserting data: $error');
      }
      print('Server response: ${response.body}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(),
        ),
      );
      _hideLoadingDialog(context);
    } else {
      print(
          'Failed to send data to the server. Status code: ${response.statusCode}');
      Fluttertoast.showToast(
        msg: response.body,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
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
                items: majorCitiesInIndia.map((city) {
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
