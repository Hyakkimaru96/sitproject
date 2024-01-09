import 'package:flutter/material.dart';
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

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({Key? key}) : super(key: key);

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
                    "User Name", //TODO
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
                        onPressed: () {},
                        heroTag: 'follow',
                        elevation: 0,
                        label: const Text("Follow"),
                        icon: const Icon(Icons.person_add_alt_1),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: 'mesage',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Message"),
                        icon: const Icon(Icons.message_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ProfileInfoRow(),
                  Expanded(
                    child: Container(
                      child: PostPage2(),
                    ),
                  )
                  // PostPage2()
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
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Posts", 900), //TODO
    ProfileInfoItem("Followers", 120), //TODO
    ProfileInfoItem("Following", 200), //TODO
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
    //! ---- REMOVE BELOW CODE ----

    setState(() {
      posts = List.generate(
          10,
          (index) => ({
                'postid': "post['postid']",
                'title': "post['title']",
                'description': "post['description']",
                'liked_by': List<String>.from([]),
                'photos': List<String>.from([]),
                'likes': 0,
                'comments': List<String>.from([]),
              }));
    });
    return;

    //! ---- REMOVE TILL HERE ----

    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    String apiUrl =
        'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/getPosts';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'email': localEmail},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey("posts")) {
        List<dynamic> fetchedPosts = jsonResponse["posts"];

        setState(() {
          posts = fetchedPosts.map<Map<String, dynamic>>((post) {
            return {
              'postid': post['postid'],
              'title': post['title'],
              'description': post['description'],
              'liked_by': List<String>.from(post['liked_by'] ?? []),
              'photos': List<String>.from(post['images'] ?? []),
              'likes': post['likes'] ?? 0,
              'comments': List<String>.from(post['comments'] ?? []),
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostPreviewCard(
                  title: post['title'],
                  description: post['description'],
                  imageUrls:
                      (post['photos'] as List<dynamic>).map<String>((photo) {
                            if (photo is String) {
                              if (photo.startsWith('http')) {
                                return photo;
                              } else {
                                return 'https://122f-2405-201-e010-f96e-601a-96f6-875d-23f7.ngrok-free.app/images/$photo';
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
    );
  }
}
