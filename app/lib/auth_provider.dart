import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // Add this line

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  String? _token;

  bool get isAuthenticated => _token != null;

  Future<bool> register(String email, String password) async {
    try {
      var response = await _apiService.registerUser({'email': email, 'password': password});
      if (response.statusCode == 200) {
        // Handle successful registration
        return true;
      }
      return false;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      var response = await _apiService.loginUser(email, password);
      if (response.statusCode == 200) {
        _token = jsonDecode(response.body)['token'];
        await _storage.write(key: 'jwt_token', value: _token);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    _token = null;
    notifyListeners();
  }

// Additional methods as needed
}
