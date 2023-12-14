import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Utilities/global.dart';
import 'dart:convert';

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController referredByController = TextEditingController();
  TextEditingController personNameController = TextEditingController();
  TextEditingController personMobileController = TextEditingController();
  TextEditingController professionalIntroController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  final List<String> citiesInTamilNadu = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Tiruchirappalli',
    'Salem',
    'Tirunelveli',
    // Add more cities as needed
  ];
  String selectedCity = 'Chennai';

  @override
  void initState() {
    super.initState();
    // Set initial values for controllers
    populateControllers({
      'name': '',
      'email': '',
      'phone': '',
      'city': citiesInTamilNadu.first, // Set default city
      'referredBy': '',
      'personName': '',
      'personMobile': '',
      'professionalIntro': '',
      'website': '',
    });
  }

  Future<void> fetchUserData() async {
    // Fetch user data from your data source or initialize with default values
    // For demonstration purposes, I'm initializing with default values
    populateControllers({
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '1234567890',
      'city': 'Chennai',
      'referredBy': 'Referrer',
      'personName': 'John Doe',
      'personMobile': '9876543210',
      'professionalIntro': 'Professional intro text...',
      'website': 'https://www.example.com',
      // Add other fields accordingly
    });
  }

  void populateControllers(Map<String, dynamic> userMap) {
    nameController.text = userMap['name'];
    emailController.text = userMap['email'];
    phoneController.text = userMap['phone'];
    cityController.text = userMap['city'];
    referredByController.text = userMap['referredBy'];
    personNameController.text = userMap['personName'];
    personMobileController.text = userMap['personMobile'];
    professionalIntroController.text = userMap['professionalIntro'];
    websiteController.text = userMap['website'];
    // Populate other fields accordingly
  }

  Future<void> updateUserData() async {
    // You can update the user data in your data source here
    // For demonstration purposes, I'm just printing the updated data
    print('Updating user data: ${toJson()}');

    String jsonData = jsonEncode(toJson());

    try {
      final response = await http.post(
        Uri.parse('http://165.232.176.210:5000/updateData'),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      // You can handle the server response here
      if (response.statusCode == 200) {
        print('Server response: ${response.body}');
      } else {
        print(
            'Failed to update data on the server. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending data to the server: $error');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'city': cityController.text,
      'referredBy': referredByController.text,
      'personName': personNameController.text,
      'personMobile': personMobileController.text,
      'professionalIntro': professionalIntroController.text,
      'website': websiteController.text,
      // Add other fields accordingly
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: updateUserData,
        child: Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            minimum: EdgeInsets.fromLTRB(16, 8, 8, 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32 - 8, 24, 04),
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                textFieldPrettier(context, nameController, 'Name'),
                textFieldPrettier(context, emailController, 'Email'),
                textFieldPrettier(context, phoneController, 'Phone'),
                DropdownButtonFormField<String>(
                  value: selectedCity,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCity = value!;
                    });
                  },
                  items: citiesInTamilNadu.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'City',
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
                textFieldPrettier(context, referredByController, 'Referred By'),
                textFieldPrettier(context, personNameController, 'Person Name'),
                textFieldPrettier(
                    context, personMobileController, 'Person Mobile No'),
                textFieldPrettier(
                    context, professionalIntroController, 'Professional Intro'),
                textFieldPrettier(context, websiteController,
                    'Websites / Social Media Handle Link'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
