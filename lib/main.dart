import 'package:flutter/material.dart';
import 'package:sit/Auth%20flow/signup.dart';
import 'package:sit/test.dart';

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
      home: SplashScreen(),
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
