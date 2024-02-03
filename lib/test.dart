import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sit/Main%20Application/connection.dart';
import 'package:sit/Main%20Application/dashboard.dart';
import 'dart:convert';
import 'package:sit/Main%20Application/post.dart';
import 'package:http/http.dart' as http;
import 'package:sit/Utilities/Database_helper.dart';

/*

REPLACE THE BELOW LINE WITH THE SPECIFIC /getPosts Endpoint for the user
String apiUrl =
        'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/getPosts';

        Remove lines in fecthPosts() lines 207
*/

class ProfilePage1 extends StatefulWidget {
  final String userName, userEmail;
  final String postCount, followingCount, followersCount;
  final bool x;

  const ProfilePage1({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.followingCount,
    required this.followersCount,
    required this.postCount,
    required this.x,
  }) : super(key: key);

  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  bool isFollowing = false;
  @override
  void initState() {
    super.initState();
    isFollowing = widget.x;
  }

  void followUser(String userEmail) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    try {
      final response = await http.post(
        Uri.parse('http://188.166.218.202/follow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': userEmail, 'localEmail': localEmail}),
      );
      if (response.statusCode == 200 &&
          response.body == 'Followed Successfully!!') {
        setState(() {
          isFollowing = true;
        });
      } else {
        print(response.body);
        print('Failed to follow user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error following user: $error');
    }
  }

  void unfollowUser(String userEmail) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    try {
      final response = await http.post(
        Uri.parse('http://188.166.218.202/unfollow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': userEmail, 'localEmail': localEmail}),
      );
      if (response.statusCode == 200 &&
          response.body == 'Unfollowed Successfully!!') {
        setState(() {
          isFollowing = false;
        });
      } else {
        print(response.body);
        print('Failed to unfollow user. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error unfollowing user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.userName,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            isFollowing = !isFollowing;
                            if (isFollowing) {
                              followUser(widget.userEmail);
                            } else {
                              unfollowUser(widget.userEmail);
                            }
                          });
                        },
                        heroTag: 'follow',
                        elevation: 0,
                        label: Text(isFollowing ? "Following" : "Follow"),
                        icon: Icon(
                          isFollowing
                              ? Icons.check_circle
                              : Icons.person_add_alt_1,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'message',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ProfileInfoRow(
                    a: widget.followersCount,
                    b: widget.followingCount,
                    c: widget.postCount,
                  ),
                  Expanded(
                    child: Container(
                      child: PostPage2(userEmail: widget.userEmail),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String a, b, c;
  const _ProfileInfoRow(
      {Key? key, required this.a, required this.b, required this.c})
      : super(key: key);

  List<ProfileInfoItem> get _items => [
        ProfileInfoItem("Posts", int.parse(c)),
        ProfileInfoItem("Followers", int.parse(a)),
        ProfileInfoItem("Following", int.parse(b)),
      ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PostPage2 extends StatefulWidget {
  final String userEmail;

  PostPage2({required this.userEmail});
  @override
  _PostPage2State createState() => _PostPage2State();
}

class _PostPage2State extends State<PostPage2> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    String apiUrl = 'http://188.166.218.202/postbyuser';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'email': widget.userEmail},
    );

    setState(() {
      posts = List.generate(
          10,
          (index) => ({
                'postid': "post['postid']",
                'title': "post['title']",
                'description': "post['description']",
                'name': "post['name']",
                'liked_by': List<String>.from([]),
                'photos': List<String>.from([]),
                'likes': 0,
                'comments': List<String>.from([]),
              }));
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey("posts")) {
        List<dynamic> fetchedPosts = jsonResponse["posts"];
        setState(() {
          posts = fetchedPosts.map<Map<String, dynamic>>((post) {
            return {
              'postid': post['postid'],
              'name': post['name'],
              'title': post['title'],
              'description': post['description'],
              'liked_by': List<String>.from(post['liked_by'] ?? []),
              'photos': List<String>.from(post['images'] ?? []),
              'likes': post['likes'] ?? 0,
              'comments': List<List<dynamic>>.from(post['comments'] ?? []),
            };
          }).toList();
        });
      } else {
        print("No posts found in the response.");
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> _navigateToFullPostDetailsPage(Map<String, dynamic> post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPostDetailsPage(post: post),
      ),
    );
    if (result != null && result is bool) {
      if (result == true || result == false) {
        fetchPosts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
        return false; // Return false to allow the back button press to continue.
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostPreviewCard(
                    name: post['name'],
                    title: post['title'],
                    description: post['description'],
                    imageUrls:
                        (post['photos'] as List<dynamic>).map<String>((photo) {
                              if (photo is String) {
                                if (photo.startsWith('http')) {
                                  return photo;
                                } else {
                                  return 'http://188.166.218.202/images/$photo';
                                }
                              }
                              return '';
                            })?.toList() ??
                            [],
                    onTap: () {
                      _navigateToFullPostDetailsPage(post);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
