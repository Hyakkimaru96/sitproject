import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        automaticallyImplyLeading: false,
        
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostPreviewCard(
            title: post['title'],
            description: post['description'],
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
  final VoidCallback onTap;

  PostPreviewCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(title),
          subtitle: Text(description),
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
      appBar: AppBar(
        title: Text(post['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['description'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Description: ${post['description']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (post['photos'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Photos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      post['photos'].length,
                      (index) => Image.asset(
                        post['photos'][index],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            if (post['videos'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Videos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      post['videos'].length,
                      (index) => Container(
                        width: 120,
                        height: 80,
                        color: Colors.grey,
                        child: Center(
                          child: Text('Video ${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (post['connections'] != null)
              _buildSection('Connections', post['connections']),
            if (post['follow'] != null) _buildSection('Follow', post['follow']),
            if (post['others'] != null) _buildSection('Others', post['others']),
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
                  image: AssetImage(item['response'][0]['image']),
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
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _photosController,
              decoration: InputDecoration(labelText: 'Photos (comma-separated)'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _videosController,
              decoration: InputDecoration(labelText: 'Videos (comma-separated)'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addPost();
                Navigator.pop(context);
              },
              child: Text('Add Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _addPost() {
    final newPost = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'photos': _photosController.text.split(',').map((e) => e.trim()).toList(),
      'videos': _videosController.text.split(',').map((e) => e.trim()).toList(),
    };

    widget.onPostAdded(newPost);
  }
}
