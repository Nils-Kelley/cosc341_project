import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String fullName = _fullNameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.0.201:5050/signup'), // Corrected URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': fullName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);

        final String message = data['message'];
        final String userId = data['userId'];
        final String accessToken = data['accessToken'];

        print('Registration successful: $message');
        print('User ID: $userId');
        print('Access Token: $accessToken');

        // Navigate to the home screen after successful registration
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        final String errorMessage = data['message'];
        print('Failed to register: $errorMessage');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  icon: Icons.person,
                  controller: _fullNameController,
                ),
                SizedBox(height: 15),
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
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement navigation to the login screen
                      },
                      child: Text(
                        'Login',
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
      ),
    );
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
