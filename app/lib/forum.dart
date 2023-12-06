import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('This is the chat screen.'),
      ),
    );
  }
}
