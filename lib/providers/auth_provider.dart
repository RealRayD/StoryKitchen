import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user; // currently logged-in Firebase user

  User? get user => _user;

  AuthProvider() {
    // Listen for auth state changes (login/logout) and update _user accordingly
    _authService.auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      return await _authService.signUpWithEmail(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      return await _authService.loginWithEmail(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  // Updates the user's display name in Firebase and refreshes the local user object
  Future<void> updateDisplayName(String name) async {
    try {
      await _user?.updateDisplayName(name);
      await _user?.reload();
      _user = _authService.auth.currentUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}