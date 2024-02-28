import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sit/Utilities/Database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:sit/test.dart';

class ConnectionsPage extends StatefulWidget {
  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late Future<List<User>> _usersFuture;
  List<String> followingEmails = [];
  bool _adminApproved = false;
  @override
  void initState() {
    super.initState();
    _fetchAdminApproval();
    _usersFuture = fetchUsers();
  }

  Future<void> _fetchAdminApproval() async {
    try {
      List<Map<String, dynamic>> userData =
          await DatabaseHelper.instance.getAllUserData();
      if (userData.isNotEmpty) {
        setState(() {
          _adminApproved = userData.first['admin_approved'] == 1;
        });
      }
    } catch (e) {
      print("Error fetching admin approval status: $e");
    }
  }

  Future<List<User>> fetchUsers() async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();

    String localEmail = allUserData.first['email'];

    final fresponse = await http.post(
      Uri.parse('http://188.166.218.202/fetchfollowings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': localEmail}),
    );

    if (fresponse.statusCode == 200 && fresponse.body != "") {
      followingEmails = List<String>.from(json.decode(fresponse.body));
    }
    final response =
        await http.get(Uri.parse('http://188.166.218.202/getusers'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      List<User> userList = jsonList
          .map((json) => User.fromJson(json))
          .where((user) => user.email != localEmail)
          .toList();
      return userList;
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _refreshData();
        return true; // Allow the page to be popped
      },
      child: Scaffold(
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
                            backgroundImage: NetworkImage(
                              'http://188.166.218.202/profile/${user.profile_pic}',
                            ),
                          ),
                          onTap: () {
                            print(followingEmails);
                            bool isFollowing =
                                followingEmails.contains(user.email);
                            print(isFollowing);
                            if (_adminApproved) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage1(
                                          userName: user.name,
                                          postCount: user.postcount,
                                          userEmail: user.email,
                                          followersCount: user.followercount,
                                          followingCount: user.followingcount,
                                          x: isFollowing,
                                          profilePic: user.profile_pic,
                                        )),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Admin Approval Pending"),
                                    content: Text(
                                        "You need admin approval to view this profile."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await fetchUsers();
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ConnectionsPage()));
  }
}

Widget _buildAdminApprovalPendingScreen() {
  return Stack(
    children: [
      // Blurred overlay
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        blendMode: BlendMode.srcOver, // Set a valid blend mode
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      // Banner
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Admin Approval Pending",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ],
  );
}

class User {
  final String postcount;
  final String followercount;
  final String followingcount;
  final String name;
  final String email;
  final String profile_pic;
  User({
    required this.postcount,
    required this.followingcount,
    required this.followercount,
    required this.name,
    required this.email,
    required this.profile_pic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      postcount: json['post_count'] ?? '',
      followercount: json['followers_count'] ?? '',
      followingcount: json['following_count'] ?? '',
      profile_pic: json['profile_pic'] ?? '',
    );
  }
}
