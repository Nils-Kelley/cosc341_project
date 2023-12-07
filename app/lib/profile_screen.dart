import 'package:flutter/material.dart';
import 'my_reviews.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the widget initializes
  }

  Future<void> fetchUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // Access the AuthProvider
    final token = authProvider.token; // Obtain the authentication token from AuthProvider
    http.Client httpClient = createHttpClient(); // Custom HTTP client
    final url = 'https://10.0.0.201:5050/user'; // Replace with your backend URL

    print('Fetching user data from: $url'); // Debugging: Print the URL you are requesting


    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token', // Include the token in the headers
    };

    final response = await httpClient.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      print('User data fetched successfully: $userData'); // Debugging: Print the fetched user data
      setState(() {
        userName = userData['username']; // Change to 'username' based on your response
        userEmail = userData['email'];
      });
    } else {
      // Handle error here
      print('Failed to fetch user data: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debugging: Print the response body for further debugging
    }
  }


  // Create a custom http client
  http.Client createHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass handshake error
    return IOClient(ioClient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.blue.shade700],
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            height: 320,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/profile.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    'My Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyReviewsScreen()), // Replace 'user_id' with actual user ID
                    );
                  },
                ),
                // Add more options as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
