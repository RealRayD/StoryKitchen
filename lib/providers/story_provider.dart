import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryProvider extends ChangeNotifier {
  List<Story> _stories = [];

  List<Story> get stories => _stories;

  // Method to fetch stories from the database
  Future<void> fetchStories() async {
    // Replace with actual database logic
    _stories = [
      Story(id: '1', title: 'Story 1', content: 'Content 1'),
      Story(id: '2', title: 'Story 2', content: 'Content 2'),
    ]; // Placeholder data
    notifyListeners();
  }

  // Method to add a new story
  Future<void> addStory(Story story) async {
    // Replace with actual database logic
    _stories.add(story);
    notifyListeners();
  }

  // Method to update an existing story
  Future<void> updateStory(Story story) async {
    // Replace with actual database logic
    final index = _stories.indexWhere((s) => s.id == story.id);
    if (index != -1) {
      _stories[index] = story;
      notifyListeners();
    }
  }

  // Method to delete a story
  Future<void> deleteStory(String storyId) async {
    // Replace with actual database logic
    _stories.removeWhere((s) => s.id == storyId);
    notifyListeners();
  }
}