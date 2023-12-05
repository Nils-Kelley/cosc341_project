import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

class ApiService {
  static const String baseUrl = 'https://10.0.0.201:5050';

  // Create a custom http client
  http.Client createHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass handshake error
    return IOClient(ioClient);
  }

  Future<http.Response> loginUser(String email, String password) async {
    var url = Uri.parse('$baseUrl/login');
    var client = createHttpClient(); // Use the custom http client

    try {
      var response = await client.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'identifier': email, 'password': password})
      );
      return response;
    } finally {
      client.close(); // Close the client
    }
  }

  Future<http.Response> registerUser(Map<String, dynamic> userData) async {
    var url = Uri.parse('$baseUrl/register');
    var client = createHttpClient(); // Use the custom http client

    try {
      var response = await client.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userData)
      );
      return response;
    } finally {
      client.close(); // Close the client
    }
  }

  Future<http.Response> logoutUser(String token) async {
    var url = Uri.parse('$baseUrl/logout');
    var client = createHttpClient(); // Use the custom http client

    try {
      var response = await client.post(
          url,
          headers: {"Authorization": "Bearer $token"}
      );
      return response;
    } finally {
      client.close(); // Close the client
    }
  }

// Add other methods as needed
}
