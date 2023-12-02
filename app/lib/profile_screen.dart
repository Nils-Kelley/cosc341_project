import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image URL
              ),
              SizedBox(height: 20),
              Text(
                'Username', // Replace with actual data
                style: TextStyle(
                  fontSize: 32,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality to edit profile
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Set your desired button color
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'My Reviews',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add functionality to navigate to user's reviews
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Add functionality to navigate to settings page
                },
              ),
              Divider(),
              // Add more options as needed
            ],
          ),
        ),
      ),
    );
  }
}
