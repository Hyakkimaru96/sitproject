import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:sit/Utilities/global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

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

    // Adding sample posts
    posts.addAll([
      {
        'title': 'Exploring Nature',
        'description': 'A beautiful day spent exploring nature trails.',
        'photos': [
          'https://picsum.photos/250?image=101',
          'https://picsum.photos/250?image=102',
        ],
        'videos': [
          'https://www.example.com/nature_video.mp4',
        ],
        'connections': [
          {
            'response': [
              {
                'name': 'Nature Lover',
                'description': 'Exploring the beauty of nature.',
                'image': 'https://picsum.photos/250?image=103',
              }
            ]
          }
        ],
      },
      {
        'title': 'Culinary Delights',
        'description': 'A culinary adventure trying new dishes and flavors.',
        'photos': [
          'https://picsum.photos/250?image=104',
          'https://picsum.photos/250?image=105',
        ],
        'videos': [
          'https://www.example.com/culinary_video.mp4',
        ],
        'follow': [
          {
            'response': [
              {
                'name': 'Foodie Explorer',
                'description': 'Exploring the world one dish at a time.',
                'image': 'https://picsum.photos/250?image=106',
              }
            ]
          }
        ],
      },
      {
        'title': 'Tech Innovations',
        'description': 'Discovering the latest tech innovations and gadgets.',
        'photos': [
          'https://picsum.photos/250?image=107',
          'https://picsum.photos/250?image=108',
        ],
        'videos': [
          'https://www.example.com/tech_video.mp4',
        ],
        'others': [
          {
            'response': [
              {
                'name': 'Tech Enthusiast',
                'description': 'Passionate about cutting-edge technology.',
                'image': 'https://picsum.photos/250?image=109',
              }
            ]
          }
        ],
      },
    ]);
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
                  title: post['title'],
                  description: post['description'],
                  url: post['photos'][0],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullPostDetailsPage(post: post),
                      ),
                    );
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
  final String description;
  final String url;
  final VoidCallback onTap;

  PostPreviewCard(
      {required this.title,
      required this.description,
      required this.onTap,
      required this.url});

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
              title: Text(title),
              subtitle: Text(description),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  url,
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
  List<Comment> comments = [
    Comment(
        text: 'Comment 1',
        timestamp: DateTime.now().subtract(Duration(minutes: 15))),
    Comment(
        text: 'Comment 2',
        timestamp: DateTime.now().subtract(Duration(minutes: 7))),
    Comment(
        text: 'Comment 3',
        timestamp: DateTime.now().subtract(Duration(minutes: 2))),
  ];

  bool isLiked = false; // New variable to track whether the post is liked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
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
              if (widget.post['description'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${widget.post['description']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (widget.post['photos'] != null)
                Column(
                  children: List.generate(
                    widget.post['photos'].length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.network(
                        widget.post['photos'][index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              SizedBox(
                  height: 16), // Add some space between photos and comments

              // Display Like button
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                    onPressed: () {
                      // Toggle the like status
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                  ),
                  Text(
                    'Like',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Display comments
              if (comments.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    // Display comments using ListView.builder
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        Comment comment = comments[index];
                        return ListTile(
                          title: Text(comment.text),
                          subtitle: Text(_formatTimestamp(comment.timestamp)),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  // Handle button click
                  _showCommentDialog(context);
                },
                child: Text('Add Comment'),
              ),
            ],
          ),
        ),
      ),
    );
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
              // Add input fields or any other widgets for the comment
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Your Comment'),
                // Add controller or onChanged callback for handling user input
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the comment submission
                  String newComment = commentController.text.trim();
                  if (newComment.isNotEmpty) {
                    // Update the state and add the new comment
                    setState(() {
                      comments.insert(0,
                          Comment(text: newComment, timestamp: DateTime.now()));
                    });

                    // Close the dialog
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

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute} on ${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

class Comment {
  final String text;
  final DateTime timestamp;

  Comment({required this.text, required this.timestamp});
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
  List<XFile>? _selectedVideos;
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
                  SizedBox(
                    height: 16,
                  ),
                  _buildVideoPicker(context),
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

  Widget _buildVideoPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            List<XFile>? videos = await _pickVideos();
            setState(() {
              _selectedVideos = videos;
            });
          },
          child: Text('Pick Videos'),
        ),
        if (_selectedVideos != null && _selectedVideos!.isNotEmpty)
          _buildVideoPreview(_selectedVideos!),
      ],
    );
  }

  Widget _buildImagePreview(List<XFile> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text('Selected Photos:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: images.map((image) => _buildImageItem(image.path)).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildVideoPreview(List<XFile> videos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text('Selected Videos:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: videos.map((video) => _buildVideoItem(video.path)).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildImageItem(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Image.file(
        File(imagePath),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildVideoItem(String videoPath) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: VideoPlayerWidget(videoPath: videoPath),
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

  Future<List<XFile>?> _pickVideos() async {
    List<XFile> videos = [];
    try {
      while (true) {
        XFile? video =
            await _imagePicker.pickVideo(source: ImageSource.gallery);
        if (video == null) {
          break;
        }
        videos.add(video);
      }
      return videos;
    } catch (e) {
      print('Error picking videos: $e');
      return null;
    }
  }

  void _addPost() {
    final newPost = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'photos': _selectedPhotos?.map((file) => file.path).toList() ?? [],
      'videos': _selectedVideos?.map((file) => file.path).toList() ?? [],
    };

    // Handle the new post, you can use this data as needed.
    print('New Post: $newPost');
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    _videoController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });

    _videoController.addListener(() {
      if (!mounted) {
        return;
      }
      if (_videoController.value.hasError) {
        print("Error: ${_videoController.value.errorDescription}");
        // Handle error, e.g., show an error message
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
