import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _authService.auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      bool success = await _authService.signUpWithEmail(email, password);
      if (success) {
        // The authStateChanges listener will handle user updates
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle errors, possibly by setting an error message in the provider
      rethrow;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      bool success = await _authService.loginWithEmail(email, password);
      if (success) {
        // The authStateChanges listener will handle user updates
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle errors
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // The authStateChanges listener will handle user updates
  }
}