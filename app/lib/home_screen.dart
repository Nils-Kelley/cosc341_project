import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of posts or items
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.star), // Example icon, replace with actual data if needed
              title: Text('Post Title $index'), // Replace with actual data
              subtitle: Text('Post description...'), // Replace with actual data
            ),
          );
        },
      ),
    );
  }
}
