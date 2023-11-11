import 'package:flutter/material.dart';

class ConnectionsPage extends StatefulWidget {
  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    // Simulating fetching users from a server, replace this with your actual implementation
    await Future.delayed(Duration(seconds: 2));
    return [
      User(id: '1', name: 'User 1', isFollowing: false),
      User(id: '2', name: 'User 2', isFollowing: true),
      // Add more users as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connections'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<User>>(
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
            List<User>? users = snapshot.data;
            return ListView.builder(
              itemCount: users!.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  trailing: user.isFollowing
                      ? Chip(
                          backgroundColor: Colors.green,
                          label: Text('Followed'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            _handleFollow(user);
                          },
                          child: Text('Follow'),
                        ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _handleFollow(User user) {
    // Handle the follow button click
    setState(() {
      user.isFollowing = true;
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
