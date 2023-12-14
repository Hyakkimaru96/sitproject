import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:sit/Utilities/global.dart';

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

class FullPostDetailsPage extends StatelessWidget {
  final Map<String, dynamic> post;

  FullPostDetailsPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 32 - 8, 24, 04),
              child: Text(
                "Update Profile",
                style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (post['description'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '${post['description']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (post['photos'] != null)
              Column(
                children: List.generate(
                  post['photos'].length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.network(
                      post['photos'][index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            // if (post['connections'] != null) _buildSection('Connections', post['connections']),
            // if (post['follow'] != null) _buildSection('Follow', post['follow']),
            // if (post['others'] != null) _buildSection('Others', post['others']),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> data) {
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
  }
}

class AddPostPage extends StatefulWidget {
  final Function(Map<String, dynamic> post) onPostAdded;

  AddPostPage({required this.onPostAdded});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _photosController = TextEditingController();
  final TextEditingController _videosController = TextEditingController();

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
                  textFieldPrettier(context, _titleController, 'Name'),
                  textFieldPrettier(
                      context, _descriptionController, 'Description'),
                  textFieldPrettier(
                      context, _photosController, 'Photos (comma-separated)'),
                  textFieldPrettier(
                      context, _videosController, 'Videos (comma-separated)'),
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

  void _addPost() {
    final newPost = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'photos': [
        'https://picsum.photos/200/300?random=1'
      ], //_photosController.text.split(',').map((e) => e.trim()).toList(),
      'videos': _videosController.text.split(',').map((e) => e.trim()).toList(),
    };

    widget.onPostAdded(newPost);
  }
}
