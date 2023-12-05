import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _refreshToken; // New field for refresh token
  String? _userId; // New field for user ID
  String? _username; // New field for username

  // Getter for access token
  String? get token => _token;

  // Getter for refresh token
  String? get refreshToken => _refreshToken;

  String? getCurrentUserID() {
    return _userId; // Return the user's ID
  }

  // Getter for user ID
  String? get userId => _userId;

  // Getter for username
  String? get username => _username;

  void setToken(String token) {
    _token = token;
    print("Token set in AuthProvider: $_token");
    notifyListeners();
  }

  // Method to set the refresh token and notify listeners
  void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
    notifyListeners();
  }

  // Inside AuthProvider's setUserData method
  void setUserData(String userId, String username) {
    _userId = userId;
    _username = username;
    notifyListeners();
    print("User ID and username set: $_userId, $_username");
  }

  // Method to clear the access token and optionally the refresh token
  void clearToken({bool clearRefreshToken = true}) {
    _token = null;
    if (clearRefreshToken) {
      _refreshToken = null;
    }
    // Your code to remove tokens and user data from storage or state management
    notifyListeners();
  }

// Add methods to handle login, logout, etc., and call notifyListeners() when you update the state
}
