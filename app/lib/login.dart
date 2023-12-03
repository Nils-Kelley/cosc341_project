import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 30),
              _buildTextField(
                labelText: 'Email',
                hintText: 'Enter your email',
                icon: Icons.email,
                controller: _emailController,
              ),
              SizedBox(height: 15),
              _buildTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                icon: Icons.lock,
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Implement your forgot password logic here
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implement navigation to the signup screen
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass handshake error

    try {
      final request = await client.postUrl(Uri.parse('https://10.0.0.201:5050/login'));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');
      request.write(jsonEncode({
        'identifier': email,
        'password': password,
      }));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody'); // Debugging line

      if (response.statusCode == 200) {
        // Navigate to HomePage upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()), // Replace HomePage with the actual home page widget
        );
      } else {
        print('Failed to login');
        // Handle login failure, show an alert dialog or a snackbar
      }
    } catch (e) {
      print('An error occurred: $e');
      // Handle exceptions, show an alert dialog or a snackbar
    } finally {
      client.close();
    }
  }



  Widget _buildTextField({
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
