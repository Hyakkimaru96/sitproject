import 'package:flutter/material.dart';
import 'package:sit/Utilities/global.dart';

void main() {
  runApp(ProfileApp());
}

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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController referredByController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController personMobileController = TextEditingController();
  final TextEditingController professionalIntroController =
      TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  final List<String> citiesInTamilNadu = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Tiruchirappalli',
    'Salem',
    'Tirunelveli',
  ];
  String selectedCity = 'Chennai';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update user data (you can replace this with your logic)
          print('Updating user data...');
        },
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
                      fontWeight: FontWeight.w600,
                    ),
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
                textFieldPrettier(
                    context, referredByController, 'Referred By'),
                textFieldPrettier(
                    context, personNameController, 'Person Name'),
                textFieldPrettier(
                    context, personMobileController, 'Person Mobile No'),
                textFieldPrettier(
                    context,
                    professionalIntroController,
                    'Professional Intro'),
                textFieldPrettier(
                    context, websiteController, 'Websites / Social Media Handle Link'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

