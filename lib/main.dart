import 'package:flutter/material.dart';
import 'package:sit/Main%20application/chat.dart';
import 'package:sit/Main%20application/dashboard.dart';
import 'package:sit/Main%20application/post.dart';
import 'package:sit/profile.dart';

import 'Auth Flow/signup.dart';
import 'Main application/connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignUpScreen(),
    );
  }
}

class newProject extends StatefulWidget {
  const newProject({super.key});

  @override
  State<newProject> createState() => _newProjectState();
}

class _newProjectState extends State<newProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(child: Center(child: Text('Hello World!'))),
    );
  }
}