import 'package:flutter/material.dart';

class UserPreferencesProvider extends ChangeNotifier {
  String _preferredGenre = '';
  int _preferredLength = 1000;

  String get preferredGenre => _preferredGenre;
  int get preferredLength => _preferredLength;

  Future<void> setPreferredGenre(String genre) async {
    _preferredGenre = genre;
    notifyListeners();
  }

  Future<void> setPreferredLength(int length) async {
    _preferredLength = length;
    notifyListeners();
  }

  // Load saved user preferences from storage on app start
  Future<void> loadPreferences() async {
    // TODO: implement persistence (e.g., SharedPreferences)
  }
}