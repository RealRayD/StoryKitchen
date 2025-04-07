import 'package:flutter/material.dart';

class UserPreferencesProvider extends ChangeNotifier {
  // Add user preference attributes here and their default values
  String _preferredGenre = '';
  int _preferredLength = 1000;

  // Getter methods
  String get preferredGenre => _preferredGenre;
  int get preferredLength => _preferredLength;

  // Setter methods to update preferences
  Future<void> setPreferredGenre(String genre) async {
    _preferredGenre = genre;
    notifyListeners();
    // Add logic to persist to local storage or database
  }

  Future<void> setPreferredLength(int length) async {
    _preferredLength = length;
    notifyListeners();
    // Add logic to persist to local storage or database
  }

  // Method to load preferences from storage
  Future<void> loadPreferences() async {
    // Add logic to load from local storage or database
    // Update attributes and call notifyListeners()
  }
}