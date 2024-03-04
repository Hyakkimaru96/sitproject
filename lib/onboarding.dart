import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sit/Utilities/Database_helper.dart';

class OnBoardPage extends StatefulWidget {
  OnBoardPage();

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController introController = TextEditingController();
  List<XFile>? _selectedPhotos;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
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
                        "Welcome",
                        style: TextStyle(
                            fontSize: 32,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("Please Complete Onboarding to continue",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(
                      height: 32,
                    ),
                    _buildPhotoPicker(context),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text("Website",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(
                      height: 8,
                    ),
                    _buildTextField(context, _titleController, 'Name'),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text("Professional Intro",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    _buildTextField(context, introController, 'Description',
                        oneLine: false),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () async {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Complete OnBoarding',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildTextField(
      BuildContext context, TextEditingController controller, String hintText,
      {bool oneLine = true}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(border: OutlineInputBorder()),
      maxLines: oneLine ? 1 : null,
      minLines: oneLine ? 1 : 5,
    );
  }

  Widget _buildPhotoPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            List<XFile>? images = await _pickImages();
            setState(() {
              _selectedPhotos = images;
            });
          },
          child: Wrap(
            children: [
              Center(
                child: SizedBox(
                  width: 48 * 2,
                  height: 48 * 2,
                  child: DottedBorder(
                      strokeWidth: 2,
                      dashPattern: [6, 6],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(48),
                      color: Colors.grey.shade400,
                      child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(
                            Icons.upload,
                            size: 40,
                            color: Colors.grey.shade600,
                          ))),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Upload Your Profile Picture',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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

  void _addPost() async {}
}
