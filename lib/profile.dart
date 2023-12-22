import 'package:flutter/material.dart';

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
  final List<String> citiesInTamilNadu = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Tiruchirappalli',
    'Salem',
    'Tirunelveli',
  ];
  String selectedCity = 'Chennai'; // Assume you get this value from the backend

  // Flag to indicate edit mode
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Toggle edit mode
          setState(() {
            isEditMode = !isEditMode;
          });
        },
        child: Icon(Icons.edit),
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
                textPrettier(context, 'Name', 'John Doe', isEditMode),
                textPrettier(context, 'Email', 'john.doe@example.com', isEditMode),
                textPrettier(context, 'Phone', '+123 456 7890', isEditMode),
                textPrettier(context, 'City', selectedCity, isEditMode),
                textPrettier(context, 'Person Name', 'Jane Doe', isEditMode),
                textPrettier(context, 'Person Mobile No', '+987 654 3210', isEditMode),
                textPrettier(context, 'Professional Intro', 'Software Developer', isEditMode),
                textPrettier(context, 'Websites / Social Media Handle Link', 'https://example.com', isEditMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textPrettier(BuildContext context, String labelText, String value, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              padding: EdgeInsets.all(8),
              child: Text(
                labelText + ':',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: isEditable
                  ? Container(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: TextEditingController(text: value),
                        onChanged: (newValue) {
                          // Handle changes if needed
                        },
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
