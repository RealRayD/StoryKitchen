import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterProvider extends ChangeNotifier {
  List<Character> _characters = [];

  List<Character> get characters => _characters;

  // Method to fetch characters from the database
  Future<void> fetchCharacters() async {
    // Replace with actual database logic
    _characters = [
      Character(id: '1', name: 'Character 1'),
      Character(id: '2', name: 'Character 2'),
    ]; // Placeholder data
    notifyListeners();
  }

  // Method to add a new character
  Future<void> addCharacter(Character character) async {
    // Replace with actual database logic
    _characters.add(character);
    notifyListeners();
  }

  // Method to update an existing character
  Future<void> updateCharacter(Character character) async {
    // Replace with actual database logic
    final index = _characters.indexWhere((c) => c.id == character.id);
    if (index != -1) {
      _characters[index] = character;
      notifyListeners();
    }
  }

  // Method to delete a character
  Future<void> deleteCharacter(String characterId) async {
    // Replace with actual database logic
    _characters.removeWhere((c) => c.id == characterId);
    notifyListeners();
  }
}