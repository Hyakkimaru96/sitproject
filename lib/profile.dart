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
      // Display posts using PostPreviewCard widget
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
              return PostPreviewCard(
                email: userEmail!, // Assuming email is required for PostPreviewCard
                name: userName!, // Assuming name is required for PostPreviewCard
                title: post.title,
                description: post.description,
                imageUrls: [post.imageUrl], // Assuming imageUrls is a list of strings
                onTap: () {
                  // Navigate to a new page to display the post in full
                  Navigator.push(
                    context,
                    MaterialPageRoute(
            builder: (context) => FullPostDetailsPage(post: {
              'title': post.title,
              'description': post.description,
              'photos': [post.imageUrl], // Assuming imageUrl is a String
              // Add other post details as needed
            }
            )),
                  );
                },
                showFollowButton: false, // Adjust as needed
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
class PostPreviewCard extends StatefulWidget {
  final String title;
  final String email;
  final String name;
  final String description;
  final List<String> imageUrls;
  final VoidCallback onTap;
  final bool showFollowButton;

  PostPreviewCard({
    required this.email,
    required this.name,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.onTap,
    this.showFollowButton = false,
  });
  @override
  _PostPreviewCardState createState() => _PostPreviewCardState();
}

class _PostPreviewCardState extends State<PostPreviewCard> {
  bool isFollowing = false;
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
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.transparent.withAlpha(0),
              leading: CircleAvatar(
                child: Icon(Icons.person, size: 16.0),
              ),
              title: Text(widget.name),
              subtitle: Text(widget.title),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  widget.imageUrls.isNotEmpty
                      ? widget.imageUrls[0]
                      : '', // Show only the first image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (widget.showFollowButton)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (isFollowing) {
                      unfollowUser(widget.email);
                    } else {
                      followUser(widget.email);
                    }
                    setState(() {
                      isFollowing = !isFollowing;
                    });
                  },
                  child: Text(isFollowing ? 'Following' : 'Follow'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FullPostDetailsPage extends StatefulWidget {
  final Map<String, dynamic> post;

  FullPostDetailsPage({required this.post});

  @override
  _FullPostDetailsPageState createState() => _FullPostDetailsPageState();
}

class _FullPostDetailsPageState extends State<FullPostDetailsPage> {
  List<Comment> comments = [];

  bool isLiked = false;
  void initializePostDetails() {
    dynamic commentsData = widget.post['comments'];

    _getLocalEmail().then((localEmail) {
      if (commentsData is List) {
        comments = commentsData.map<Comment>((commentData) {
          if (commentData is List && commentData.length >= 4) {
            String person =
                commentData[1] == localEmail ? "You" : commentData[2];

            return Comment(
              timestamp: commentData[0],
              person: person,
              text: commentData[3],
              url:
                  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
            );
          } else {
            // Handle unexpected comment structure
            return Comment(
              timestamp: '',
              person: '',
              text: 'Invalid comment structure',
              url: '',
            );
          }
        }).toList();
        comments = comments.reversed.toList();
      } else {
        comments = [];
      }
      print(comments);
    });
  }

  @override
  void initState() {
    super.initState();
    initializePostDetails();
    List<String> likedBy = widget.post['liked_by']?.cast<String>() ?? [];
    String localEmail = '';
    _getLocalEmail().then((email) {
      localEmail = email;
      setState(() {
        isLiked = likedBy.contains(localEmail);
      });
    });
  }

  Future<String> _getLocalEmail() async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    return allUserData.first['email'];
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = widget.post['photos']?.cast<String>() ?? [];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, isLiked);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                ),
                SizedBox(
                  height: 8,
                ),
                if (widget.post['name'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16.0),
                        SizedBox(width: 8),
                        Text(
                          '${widget.post['name']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                if (widget.post['title'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${widget.post['title']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                if (widget.post['description'] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${widget.post['description']}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                if (widget.post['photos'] != null)
                  Column(
                    children: List.generate(
                      imageUrls.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.network(
                          'http://188.166.218.202/images/${imageUrls[index]}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                    height: 16), // Add some space between photos and comments
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        _likePost(widget.post['postid']);
                      },
                    ),
                    InkWell(
                      onTap: () {
                        List<Map<String, String>> likes = [];

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                clipBehavior: Clip.antiAlias,
                                child: ListView(children: [
                                  ...List.generate(likes.length, (index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                      title: Text('User'),
                                    );
                                  })
                                ]));
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Likes"),
                      ),
                    ),
                  ],
                ),
                if (comments.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comments:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            Comment comment = comments[index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person, size: 16.0),
                              ),
                              title: Text(comment.person),
                              subtitle: Text(comment.text),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),

                ElevatedButton(
                  onPressed: () {
                    _showCommentDialog(context);
                  },
                  child: Text('Add Comment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _likePost(String id) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    print(id);
    final String apiUrl = 'http://188.166.218.202/likePost';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'postId': id.toString(),
          'email': localEmail,
          'action': isLiked ? 'unlike' : 'like',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isLiked = !isLiked;
        });
        print(isLiked);
      } else {
        print(
            'Failed to ${isLiked ? 'unlike' : 'like'} the post. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error ${isLiked ? 'unliking' : 'liking'} the post: $e');
    }
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController commentController = TextEditingController();

        return AlertDialog(
          title: Text('Add a Comment'),
          content: Column(
            children: [
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Your Comment'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String newComment = commentController.text.trim();
                  if (newComment.isNotEmpty) {
                    Comment comment = Comment(
                      url:
                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                      text: newComment,
                      person: "You",
                      timestamp: _formatTimestamp(DateTime.now()),
                    );
                    setState(() {
                      comments.insert(0, comment);
                    });
                    _submitComment(newComment, comment.timestamp);
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit Comment'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitComment(String newComment, String time) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    String postId = widget.post['postid'];

    final String apiUrl = 'http://188.166.218.202/addComment';
    print(time);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'time': time,
          'postId': postId,
          'email': localEmail,
          'commentText': newComment,
        },
      );

      if (response.statusCode == 200) {
        print('Comment submitted successfully');
      } else {
        print('Failed to submit comment. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error submitting comment: $e');
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute} on ${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
class Comment {
  final String text;
  final String timestamp;
  final String person;
  final String url;
  Comment(
      {required this.text,
      required this.person,
      required this.timestamp,
      required this.url});
}
