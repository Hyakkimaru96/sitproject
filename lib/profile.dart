import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sit/Auth%20flow/signup.dart';

import 'package:sit/Utilities/Database_helper.dart';

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
  File? _profileImage;
  final List<String> citiesInTamilNadu = [
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
  String? selectedCity =
      'Chennai'; // Assume you get this value from the backend
  String? userName = '';
  String? userEmail = '';
  String? userPhone = '';
  String? profile_pic = '';
  String? intro = '';
  String? website = '';

  bool isEditMode = false;
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        uploadImage(_profileImage!);
      });
    }
  }

  Future<void> uploadImage(File imageFile) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    final url = Uri.parse('http://188.166.218.202/uploadpp');
    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['email'] = localEmail;

    final response = await request.send();
    String responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      print(responseBody);
      await DatabaseHelper.instance.updateProfilepp(localEmail, responseBody);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

  Future<void> fetchUserData() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    Map<String, dynamic>? userData = await dbHelper.getUserData(localEmail);
    print(userData);
    if (userData != null) {
      print('User Data:');
      print('Name: ${userData['name']}');
      print('Email: ${userData['email']}');
      print('Phone: ${userData['phone']}');
      print('City: ${userData['city']}');
      print('Person Name: ${userData['personName']}');
      print('Person Phone: ${userData['personPhone']}');
      print('mPIN: ${userData['mpin']}');
      print('Is Verified: ${userData['is_verified'] == 1 ? true : false}');
      print('Intro : ${userData['intro']}');
      print('Website : ${userData['website']}');
      print('Profile pic: ${userData['profile_pic']}');
      setState(() {
        userName = userData['name'] ?? '';
        userEmail = userData['email'] ?? '';
        userPhone = userData['phone'] ?? '';
        website = userData['website'] ?? '';
        intro = userData['intro'] ?? '';
        selectedCity = userData['city'] ?? citiesInTamilNadu[0];
        profile_pic = userData['profile_pic'];
      });
    } else {
      print('User not found!');
    }
    // Initialize variables with fetched data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            minimum: EdgeInsets.fromLTRB(16, 0, 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? Image.file(
                            File(_profileImage!.path),
                            fit: BoxFit.cover,
                          ).image
                        : _profileImage == null
                            ? NetworkImage(
                                'http://188.166.218.202/profile/${profile_pic}')
                            : null,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32 - 8, 24, 04),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 32,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                textPrettier(context, 'Name', userName!, isEditMode),
                textPrettier(context, 'Email', userEmail!, isEditMode),
                textPrettier(context, 'Phone', userPhone!, isEditMode),
                textPrettier(context, 'City', selectedCity!, isEditMode),
                textPrettier(context, 'Professional Intro', intro, isEditMode),
                textPrettier(context, 'Websites / Social Media Handle Link',
                    website, isEditMode),
                SizedBox(height: 20),
                // Display posts below other information
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textPrettier(
      BuildContext context, String labelText, String? value, bool isEditable) {
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
                        onChanged: (newValue) {},
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        value ?? 'N/A',
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

  // Function to show a confirmation dialog before logging out
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteUser();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
