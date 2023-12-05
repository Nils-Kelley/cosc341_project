import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'main.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String username = _usernameController.text;
    final String fullName = _fullNameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final client = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => host == '10.0.0.201';

    try {
      final request = await client.postUrl(Uri.parse('https://10.0.0.201:5050/register'));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json; charset=UTF-8');
      request.write(jsonEncode({
        'username': username,
        'fullname': fullName,
        'email': email,
        'password': password,
      }));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 201) {
        final responseData = json.decode(responseBody);
        final token = responseData['token']; // Assuming your API returns a token
        if (token != null) {
          // Store the token using AuthProvider
          Provider.of<AuthProvider>(context, listen: false).setToken(token);
          // Navigate to HomeScreen upon successful registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          print('Registration successful, but no token received');
        }
      } else {
        final Map<String, dynamic> data = json.decode(responseBody);
        final String errorMessage = data['message'];
        print('Failed to register: $errorMessage');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      client.close();
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
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  icon: Icons.person_outline,
                  controller: _usernameController,
                ),
                SizedBox(height: 15),
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
