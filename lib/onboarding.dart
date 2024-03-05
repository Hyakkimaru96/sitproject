import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sit/Main%20Application/dashboard.dart';
import 'dart:convert';
import 'package:sit/Utilities/Database_helper.dart';

class OnBoardPage extends StatefulWidget {
  OnBoardPage();

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController introController = TextEditingController();
  File? _profileImage;
  String? profile_pic = '';
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        uploadImage(_profileImage!);
      });
    }
  }

  Future<void> uploadImage(File imageFile) async {
    await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> allUserData =
        await DatabaseHelper.instance.getAllUserData();
    String localEmail = allUserData.first['email'];
    final url = Uri.parse('http://188.166.218.202/uploadpp');
    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['email'] = localEmail;

    final response = await request.send();
    String responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      print(responseBody);
      await DatabaseHelper.instance.updateProfilepp(localEmail, responseBody);
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
    }
  }

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
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors
                            .grey, // Add a background color for the avatar
                        child: _profileImage != null
                            ? ClipOval(
                                child: Image.file(
                                  File(_profileImage!.path),
                                  fit: BoxFit.cover,
                                  width:
                                      120, // Optional: Set the width and height of the image
                                  height: 120,
                                ),
                              )
                            : _profileImage == null
                                ? ClipOval(
                                    child: Image.network(
                                      'http://188.166.218.202/profile/default_profile_image.jpg',
                                      fit: BoxFit.cover,
                                      width:
                                          120, // Optional: Set the width and height of the image
                                      height: 120,
                                    ),
                                  )
                                : null,
                      ),
                    ),
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
            onTap: () async {
              await DatabaseHelper.instance.database;
              List<Map<String, dynamic>> allUserData =
                  await DatabaseHelper.instance.getAllUserData();
              String localEmail = allUserData.first['email'];
              String apiUrl = 'http://188.166.218.202/additional';
              Map<String, String> headers = {
                'Content-Type': 'application/json'
              };
              Map<String, dynamic> body = {
                'website': _titleController.text,
                'intro': introController.text,
                'email': localEmail
              };
              try {
                http.Response response = await http.post(
                  Uri.parse(apiUrl),
                  headers: headers,
                  body: jsonEncode(body),
                );
                if (response.statusCode == 200) {
                  await DatabaseHelper.instance.insertAdditional(
                      email: localEmail,
                      website: _titleController.text,
                      intro: introController.text);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dashboard(),
                    ),
                  );
                }
              } catch (e) {
                print('Error during HTTP request: $e');
                Fluttertoast.showToast(
                  msg: 'Error during adding information. Please try again.',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
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
}
