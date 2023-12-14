import 'package:flutter/material.dart';

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
                          title: Text(user.name),
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          trailing: user.isFollowing
                              ? ElevatedButton(
                                  onPressed: () {
                                    // Handle follow action here
                                  },
                                  child: Text('Followed'),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    _handleFollow(user);
                                  },
                                  child: Text('Follow'),
                                ));
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
