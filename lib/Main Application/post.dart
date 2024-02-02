import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:path/path.dart';
import 'package:sit/Utilities/global.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sit/Utilities/Database_helper.dart';

void main() {
  runApp(MaterialApp(
    home: PostPage(),
  ));
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Map<String, dynamic>> posts = [];
  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    final String apiUrl = 'http://188.166.218.202/getPosts';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'email': localEmail},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey("posts")) {
        List<dynamic> fetchedPosts = jsonResponse["posts"];
        print(fetchedPosts);
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

  Future<void> _navigateToFullPostDetailsPage(
      Map<String, dynamic> post, BuildContext context) async {
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
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 32, 24, 04),
            child: Text(
              "Posts",
              style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
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
                    _navigateToFullPostDetailsPage(post, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
        closedBuilder: (context, action) {
          return FloatingActionButton(
            onPressed: action,
            child: Icon(Icons.add),
          );
        },
        openBuilder: (context, action) {
          return AddPostPage(
            onPostAdded: (newPost) {
              setState(() {
                posts.add(newPost);
              });
            },
          );
        },
        tappable: false,
      ),
    );
  }
}

class PostPreviewCard extends StatelessWidget {
  final String title;
  final String name;
  final String description;
  final List<String> imageUrls;
  final VoidCallback onTap;

  PostPreviewCard({
    required this.name,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.transparent.withAlpha(0),
              leading: CircleAvatar(
                child: Icon(Icons.person, size: 16.0),
              ),
              title: Text(name),
              subtitle: Text(title),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  imageUrls.isNotEmpty
                      ? imageUrls[0]
                      : '', // Show only the first image
                  fit: BoxFit.cover,
                ),
              ),
            )
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

/*Widget _buildSection(String title, List<Map<String, dynamic>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(  
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        for (var item in data)
          ListTile(
            title: Text(item['response'][0]['name']),
            subtitle: Text(item['response'][0]['description']),
            trailing: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item['response'][0]['image']),
                ),
              ),
            ),
          ),
      ],
    );
  }*/

class AddPostPage extends StatefulWidget {
  final Function(Map<String, dynamic> post) onPostAdded;

  AddPostPage({required this.onPostAdded});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<XFile>? _selectedPhotos;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32 - 8, 24, 04),
                    child: Text(
                      "Add Post",
                      style: TextStyle(
                          fontSize: 32,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildTextField(context, _titleController, 'Name'),
                  _buildTextField(
                      context, _descriptionController, 'Description'),
                  SizedBox(
                    height: 16,
                  ),
                  _buildPhotoPicker(context),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPost();
          Navigator.pop(context);
        },
        child: Icon(Icons.done),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: hintText),
    );
  }

  Widget _buildPhotoPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            List<XFile>? images = await _pickImages();
            setState(() {
              _selectedPhotos = images;
            });
          },
          child: Text('Pick Photos'),
        ),
        if (_selectedPhotos != null && _selectedPhotos!.isNotEmpty)
          _buildImagePreview(_selectedPhotos!),
      ],
    );
  }

  Widget _buildImagePreview(List<XFile> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text('Selected Photos:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _buildImageItem(images[index].path);
            },
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildImageItem(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Future<List<XFile>?> _pickImages() async {
    try {
      return await _imagePicker.pickMultiImage();
    } catch (e) {
      print('Error picking images: $e');
      return null;
    }
  }

  void _addPost() async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    final newPost = {
      'email': localEmail,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'photos': _selectedPhotos?.map((file) => file.path).toList() ?? [],
    };
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://188.166.218.202/upload'));
      newPost.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      if (_selectedPhotos != null) {
        for (var i = 0; i < _selectedPhotos!.length; i++) {
          var file = await http.MultipartFile.fromPath(
            'photos',
            _selectedPhotos![i].path,
          );
          request.files.add(file);
        }
      }

      var response = await http.Response.fromStream(await request.send());
      print('Server Response: ${response.body}');

      widget.onPostAdded(newPost);
    } catch (e) {
      print('Error uploading images: $e');
    }
    print('New Post: $newPost');
    widget.onPostAdded(newPost);
  }
}
