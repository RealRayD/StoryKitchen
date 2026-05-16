import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/character.dart';
import '../services/firestore_service.dart';

class CharacterProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Character> _characters = [];
  StreamSubscription? _charactersSubscription; // live Firestore stream subscription
  StreamSubscription? _authSubscription;       // auth state listener subscription

  CharacterProvider() {
    // Watch for login/logout events and start/stop the character stream accordingly
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _initCharacters(user.uid);
      } else {
        _characters = [];
        _charactersSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  List<Character> get characters => _characters;

  // Subscribe to the live Firestore stream for this user's characters
  void _initCharacters(String uid) {
    _charactersSubscription?.cancel();
    _charactersSubscription = _firestoreService.streamCharacters(uid).listen(
      (data) {
        _characters = data;
        notifyListeners();
      },
      onError: (error) {
        print('CharacterProvider error: $error');
      },
    );
  }

  Future<void> addCharacter(Character character) async {
    await _firestoreService.saveCharacter(character);
  }

  Future<void> removeCharacter(Character character) async {
    await _firestoreService.deleteCharacter(character.id);
  }

  Future<void> updateCharacter(Character character) async {
    await _firestoreService.saveCharacter(character);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _charactersSubscription?.cancel();
    super.dispose();
  }
}