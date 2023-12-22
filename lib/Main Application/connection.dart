import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sit/Main%20Application/chat.dart';
import 'package:sit/Utilities/global.dart';
import 'package:sit/Utilities/Database_helper.dart';
import 'package:http/http.dart' as http;

class ConnectionsPage extends StatefulWidget {
  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late Future<List<User>> _usersFuture;
  late List<bool> isFollowingList;
  @override
  void initState() {
    super.initState();
    isFollowingList = [];
    _usersFuture = fetchUsers();
  }

  void unfollowUser(String userEmail, int index) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    try {
      final response = await http.post(
        Uri.parse(
            'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/unfollow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': userEmail, 'localEmail': localEmail}),
      );
      if (response.statusCode == 200 &&
          response.body == 'Unfollowed Successfully!!') {
        setState(() {
          isFollowingList[index] = false;
        });
      } else {
        print(response.body);
        print('Failed to unfollow user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error unfollowing user: $error');
    }
  }

  void followUser(String userEmail, int index) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    try {
      final response = await http.post(
        Uri.parse(
            'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/follow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': userEmail, 'localEmail': localEmail}),
      );
      if (response.statusCode == 200 &&
          response.body == 'Followed Successfully!!') {
        setState(() {
          isFollowingList[index] = true;
        });
      } else {
        print(response.body);
        print('Failed to follow user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error following user: $error');
    }
  }

  Future<List<User>> fetchUsers() async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();

    // Extract the email from local data
    String localEmail = allUserData.first['email'];

    final fresponse = await http.post(
      Uri.parse(
          'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/fetchfollowings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': localEmail}),
    );
    List<String> followingEmails = [];
    if (fresponse.statusCode == 200 && fresponse.body != "") {
      followingEmails = List<String>.from(json.decode(fresponse.body));
    }
    print(followingEmails);
    final response = await http.get(Uri.parse(
        'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/getusers'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      List<User> userList = jsonList
          .map((json) => User.fromJson(json))
          .where((user) =>
              user.email != localEmail && !followingEmails.contains(user.email))
          .toList();

      return userList;
    } else {
      throw Exception('Failed to load users');
    }
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
                  if (isFollowingList.isEmpty) {
                    isFollowingList = List.filled(snapshot.data!.length, false);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        title: Text(
                          user.name,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        leading: CircleAvatar(
                          radius: 28.0,
                          child: Icon(Icons.person, size: 32.0),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditor(
                                name: user.name,
                                email: 'example@email.com',
                                professionalIntro: 'Professional intro text...',
                                website: 'https://www.example.com',
                              ),
                            ),
                          );
                        },
                        trailing: ElevatedButton(
                          onPressed: () {
                            if (isFollowingList[index]) {
                              unfollowUser(user.email, index);
                            } else {
                              followUser(user.email, index);
                            }
                          },
                          child: Text(
                            isFollowingList[index] ? 'Unfollow' : 'Follow',
                          ),
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
}

class User {
  final String email;
  final String name;

  User({
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle the "Connections" button press
                    print('Connections button pressed');
                  },
                  child: Text('Connections'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
