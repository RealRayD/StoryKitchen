import 'package:flutter/material.dart';
import '../models/story_settings.dart';
import '../models/story.dart'; // Import the Story model

class StoryGenerationProvider extends ChangeNotifier {
  StorySettings _settings = StorySettings();
  Story? _generatedStory; // Add a field to hold the generated story
  bool _isLoading = false; // Add a field to track loading state

  StorySettings get settings => _settings;
  Story? get generatedStory => _generatedStory; // Getter for the generated story
  bool get isLoading => _isLoading; // Getter for loading state

  // Method to update story settings
  void updateSettings(StorySettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  // Method to trigger story generation
  Future<void> generateStory() async {
    _isLoading = true; // Set loading state to true
    notifyListeners();
    // Replace with actual AI integration logic
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    _generatedStory = Story(id: 'temp', title: 'Generated Story', content: 'This is a placeholder story.'); // Placeholder story
    _isLoading = false; // Set loading state to false
    notifyListeners();
  }
}