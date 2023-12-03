import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';
import 'signup.dart';

class SignupMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Welcome to Rate It',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SvgPicture.asset(
              'assets/logo.svg',
              height: 120,
              width: 120,
              alignment: Alignment.center,
            ),
            SizedBox(height: 8),
            Text(
              'Discover. Rate. Share.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 35),
            _buildButton(context, 'Login', Colors.blue, Colors.white, LoginScreen()),
            SizedBox(height: 20),
            _buildButton(context, 'Sign Up', Colors.white, Colors.blue, SignupScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color bgColor, Color textColor, Widget route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 18)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
    );
  }
}
