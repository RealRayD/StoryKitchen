import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/story.dart';
import '../services/firestore_service.dart';

class StoryProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Story> _stories = [];
  StreamSubscription? _storiesSubscription; // live Firestore stream subscription
  StreamSubscription? _authSubscription;    // auth state listener subscription

  StoryProvider() {
    // Watch for login/logout and start/stop the story stream accordingly
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _initStories(user.uid);
      } else {
        _stories = [];
        _storiesSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  List<Story> get stories => _stories;

  // Subscribe to the live Firestore stream for this user's stories
  void _initStories(String uid) {
    _storiesSubscription?.cancel();
    _storiesSubscription = _firestoreService.streamStories(uid).listen(
      (data) {
        _stories = data;
        notifyListeners();
      },
      onError: (error) {
        print('StoryProvider error: $error');
      },
    );
  }

  Future<void> addStory(Story story) async {
    await _firestoreService.saveStory(story);
  }

  Future<void> updateStory(Story story) async {
    await _firestoreService.saveStory(story);
  }

  Future<void> deleteStory(String storyId) async {
    await _firestoreService.deleteStory(storyId);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _storiesSubscription?.cancel();
    super.dispose();
  }
}