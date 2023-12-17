import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sit/Main%20Application/chat.dart';
import 'package:sit/Utilities/global.dart';

class ConnectionsPage extends StatefulWidget {
  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late Future<List<User>> _usersFuture;
  List<User> users = [
    User(id: '1', name: 'Johnathan', isFollowing: false),
    User(id: '2', name: 'Stacy', isFollowing: false),
    User(id: '3', name: 'John', isFollowing: false),
    User(id: '4', name: 'Stacy', isFollowing: false),
    User(id: '5', name: 'Ram', isFollowing: false),
    User(id: '6', name: 'Shyam', isFollowing: false),
    // Add more users as needed
  ];

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    // Simulating fetching users from a server, replace this with your actual implementation
    await Future.delayed(Duration(milliseconds: 100));
    return [
      User(id: '1', name: 'User 1', isFollowing: false),
      User(id: '2', name: 'User 2', isFollowing: true),
      // Add more users as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 24, 04),
            child: Text(
              "Connections",
              style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No users available.'),
                  );
                } else {
                  // Data is loaded successfully, build the user list
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust padding as needed
                        title: Text(
                          user.name,
                          style: TextStyle(fontSize: 18.0), // Increase the font size as needed
                        ),
                        leading: CircleAvatar(
                          radius: 28.0, // Increase the radius as needed
                          child: Icon(Icons.person, size: 32.0), // Adjust size as needed
                        ),
                        onTap: () {
                    // Navigate to the profile editor page when ListTile is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEditor(
                          name: user.name,
                          email: 'example@email.com', // Provide user email
                          professionalIntro: 'Professional intro text...',
                          website: 'https://www.example.com',
                        ),
                      ),
                    );
                  },
                        trailing: ElevatedButton(
                          onPressed: () {
                            _handleFollow(user);
                          },
                          child: Text(user.isFollowing ? 'Followed' : 'Follow'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleFollow(User user) {
    // Handle the follow button click
    setState(() {
      user.isFollowing = !user.isFollowing;
    });
  }
}

class User {
  final String id;
  final String name;
  bool isFollowing;

  User({
    required this.id,
    required this.name,
    required this.isFollowing,
  });
}

class ProfileEditor extends StatefulWidget {
  final String name;
  final String email;
  final String professionalIntro;
  final String website;

  ProfileEditor({
    required this.name,
    required this.email,
    required this.professionalIntro,
    required this.website,
  });

  @override
  _ProfileEditorState createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController professionalIntroController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for controllers
    populateControllers();
  }

  void populateControllers() {
    nameController.text = widget.name;
    emailController.text = widget.email;
    professionalIntroController.text = widget.professionalIntro;
    websiteController.text = widget.website;
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
      'professionalIntro': professionalIntroController.text,
      'website': websiteController.text,
      // Add other fields accordingly
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Editor'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
        actions: [
          // Add a chat button in the app bar
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              // Navigate to the chat screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            minimum: EdgeInsets.fromLTRB(16, 8, 8, 16),
            child: Column(
              children: [
                textFieldPrettier(context, nameController, 'Name'),
                textFieldPrettier(context, emailController, 'Email'),
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
