import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of posts or items
        itemBuilder: (context, index) {
          return Card(
            elevation: 2, // Add shadow to the card
            margin: EdgeInsets.all(16), // Adjust margins
            child: ListTile(
              leading: Icon(Icons.star), // Example icon, replace with actual data if needed
              title: Text(
                'Post Title $index', // Replace with actual data
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Post description...', // Replace with actual data
              ),
              onTap: () {
                // Handle item tap if needed
              },
            ),
          );
        },
      ),
    );
  }
}
