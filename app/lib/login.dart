import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'main.dart';
import 'api_service.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Wrap the entire screen in a Scaffold widget
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
                labelText: 'Username',
                hintText: 'Enter your username',
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await _apiService.loginUser(email, password);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final userId = responseData['userId']; // Assuming the API response contains the user ID

        if (token != null) {
          // Store the token and user ID using AuthProvider
          Provider.of<AuthProvider>(context, listen: false).setToken(token);
          Provider.of<AuthProvider>(context, listen: false).setUserData(userId.toString(), email);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          _showSnackBar('Login failed. Please check your credentials.');
        }
      } else {
        _showSnackBar('Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}