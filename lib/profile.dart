import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sit/Auth%20flow/signup.dart';

import 'package:sit/Utilities/Database_helper.dart';

void main() {
  runApp(ProfileApp());
}

class Post {
  final String title;
  final String description;
  final String imageUrl;

  Post({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class FullPostPage extends StatelessWidget {
  final Post post;

  FullPostPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              post.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Image.network(post.imageUrl),
          ],
        ),
      ),
    );
  }
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
  String? userName='';
  String? userEmail='';
  String? userPhone='';

  bool isEditMode = false;
  @override
  void initState() {
    super.initState();
    // Fetch user data from the database and initialize variables
    fetchUserData();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchUserData() async {
    // Replace with actual database helper method to fetch user data
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
      setState(() {
        userName = userData['name'] ?? '';
        userEmail = userData['email'] ?? '';
        userPhone = userData['phone'] ?? '';
        selectedCity = userData['city'] ??
            citiesInTamilNadu[0]; // Default to the first city if not available
      });
    } else {
      print('User not found!');
    }
    // Initialize variables with fetched data
  }

  Future<List<Post>> fetchPosts() async {
    // Simulate fetching posts from the server
    await Future.delayed(Duration(seconds: 1));

    // Dummy post data
    List<Post> posts = [
      Post(
        title: 'Post 1',
        description: 'Description for Post 1',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Post(
        title: 'Post 2',
        description: 'Description for Post 2',
        imageUrl: 'https://via.placeholder.com/150',
      ),
      // Add more dummy posts as needed
    ];

    return posts;
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      actions: [
        // Add a logout button in the app bar
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // Implement the logout functionality here
            // For example, you can show a confirmation dialog and navigate to the login page
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
                        : AssetImage('assets/default_profile_image.png'),
                  ),
                ),
              SizedBox(height: 20),
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
              textPrettier(context, 'Name', userName!, isEditMode),
              textPrettier(context, 'Email', userEmail!, isEditMode),
              textPrettier(context, 'Phone', userPhone!, isEditMode),
              textPrettier(context, 'City', selectedCity!, isEditMode),
              textPrettier(context, 'Professional Intro',
                  'Software Developer', isEditMode),
              textPrettier(context, 'Websites / Social Media Handle Link',
                  'https://example.com', isEditMode),
              SizedBox(height: 20),
              // Display posts below other information
              FutureBuilder<List<Post>>(
                future: fetchPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    // Display posts
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Posts',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: snapshot.data!.length,
  itemBuilder: (context, index) {
    Post post = snapshot.data![index];
    return GestureDetector(
      onTap: () {
        // Navigate to a new page to display the post in full
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPostPage(post: post),
          ),
        );
      },
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.description),
        leading: Image.network(post.imageUrl),
      ),
    );
  },
),
                      ],
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Toggle edit mode
        setState(() {
          isEditMode = !isEditMode;
        });
      },
      child: Icon(Icons.edit),
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
                // Close the dialog
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
