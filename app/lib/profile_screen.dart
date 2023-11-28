import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Card(
          elevation: 4, // Add shadow to the card
          margin: EdgeInsets.all(16), // Add margin to the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Add rounded corners to the card
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image URL
                ),
                SizedBox(height: 16),
                Text(
                  'Username', // Replace with actual data
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'user@example.com', // Replace with actual data
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                // Add more personal details or options here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
