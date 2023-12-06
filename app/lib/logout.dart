import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth_provider.dart'; // Import the AuthProvider class

Future<void> logoutUser(BuildContext buildContext, AuthProvider authProvider) async {
  try {
    final SecurityContext secContext = SecurityContext.defaultContext;

    final client = HttpClient(context: secContext)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return host == '192.168.1.253';
      };

    final request = await client.postUrl(Uri.parse('https://192.168.1.253:5050/logout'));
    request.headers.contentType = ContentType.json;
    request.headers.add('Authorization', 'Bearer ${authProvider.token}');

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      authProvider.clearToken(); // Remove token from AuthProvider (you'll need to implement clearToken)
      Navigator.pushReplacementNamed(buildContext, '/');
    } else {
      print("Failed to logout. Status Code: ${response.statusCode}, Body: $responseBody");
      // Handle error here
    }
  } catch (e) {
    if (e is SocketException) {
      print('Network issues found: $e');
    } else if (e is HttpException) {
      print('HTTP issues found: $e');
    } else if (e is FormatException) {
      print('Data formatting issue found: $e');
    } else {
      print("An unknown error occurred: $e");
    }
    // Handle error here
  }
}