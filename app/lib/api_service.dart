import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://10.0.0.201:5050';

  Future<http.Response> registerUser(Map<String, dynamic> userData) async {
    var url = Uri.parse('$baseUrl/register');
    var response = await http.post(url, body: jsonEncode(userData), headers: {"Content-Type": "application/json"});
    return response;
  }

  Future<http.Response> loginUser(String email, String password) async {
    var url = Uri.parse('$baseUrl/login');
    var response = await http.post(url, body: jsonEncode({'email': email, 'password': password}), headers: {"Content-Type": "application/json"});
    return response;
  }

  Future<http.Response> logoutUser(String token) async {
    var url = Uri.parse('$baseUrl/logout');
    var response = await http.post(url, headers: {"Authorization": "Bearer $token"});
    return response;
  }

// Add other methods as needed
}
