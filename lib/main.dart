import 'package:flutter/material.dart';
import 'views/post_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PostScreen(),
    );
  }
}
