import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/story_settings.dart';
import '../services/gemini_service.dart';
import '../models/story.dart';

class StoryGenerationProvider extends ChangeNotifier {
  StorySettings _settings = StorySettings();
  Story? _generatedStory;
  ChatSession? _chatSession; // persists across chapters for narrative continuity

  bool _isLoading = false;
  int _currentChapter = 0;

  final _geminiService = GeminiService();

  StorySettings get settings => _settings;
  Story? get generatedStory => _generatedStory;
  bool get isLoading => _isLoading;
  int get currentChapter => _currentChapter;
  int get maxChapters => _settings.isMultiChapter ? _settings.chapterCount : 1;
  bool get hasMoreChapters => _currentChapter < maxChapters;

  void updateSettings(StorySettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  // Generates chapter 1 and opens a chat session for future chapters
  Future<void> generateStory() async {
    _isLoading = true;
    _generatedStory = null;
    _chatSession = null;
    _currentChapter = 0;
    notifyListeners();

    try {
      final result = await _geminiService.startStorySession(_settings);
      final storyContent = result['content'] as String;
      _chatSession = result['session'] as ChatSession;
      _currentChapter = 1;

      String title = 'Untitled Story';
      String finalContent = storyContent;

      // Extract and strip the title line so it doesn't show twice in the reader
      final titleMatch = RegExp(r'^(Title:|Chapter 1:)\s*(.*)', multiLine: true).firstMatch(storyContent);
      if (titleMatch != null) {
        title = titleMatch.group(2)?.trim() ?? 'Untitled Story';
        finalContent = storyContent.replaceFirst(titleMatch.group(0)!, '').trim();
      }

      _generatedStory = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '',
        title: title,
        content: finalContent,
        genres: _settings.genres,
        length: _settings.length,
        mood: _settings.mood,
        featuredCharacters: _settings.characters.map((e) => e.name).toList(),
      );
    } catch (e) {
      _generatedStory = Story(
        id: 'error',
        userId: '',
        title: 'Error',
        content: 'Failed to generate story: $e',
      );
      print('StoryGenerationProvider error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Appends the next chapter to the existing story content using the active session
  Future<void> generateNextChapter() async {
    if (_chatSession == null || !hasMoreChapters) return;

    _isLoading = true;
    notifyListeners();

    try {
      final nextChapterNumber = _currentChapter + 1;
      final chapterContent = await _geminiService.generateNextChapter(
        _chatSession!,
        nextChapterNumber,
        maxChapters,
        _settings.length,
      );

      _currentChapter = nextChapterNumber;

      if (_generatedStory != null) {
        final updatedContent = _generatedStory!.content + '\n\n---\n\n' + chapterContent;
        _generatedStory = _generatedStory!.copyWith(content: updatedContent);
      }
    } catch (e) {
      print('StoryGenerationProvider chapter error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}