import 'character.dart';

class StorySettings {
  List<String> genres;
  int length;
  String mood;
  String readingLevel;
  String setting;
  String customPrompt;
  String language;
  String style;
  bool isMultiChapter; // generates chapters one at a time
  int chapterCount;    // how many chapters to generate in total
  List<Character> characters;

  StorySettings({
    this.genres = const ['Fantasy'],
    this.length = 1000,
    this.mood = 'Lighthearted',
    this.readingLevel = 'Young Adult',
    this.setting = '',
    this.customPrompt = '',
    this.language = 'English',
    this.style = 'Regular',
    this.isMultiChapter = false,
    this.chapterCount = 1,
    this.characters = const [],
  });

  StorySettings copyWith({
    List<String>? genres,
    int? length,
    String? mood,
    String? readingLevel,
    String? setting,
    String? customPrompt,
    String? language,
    String? style,
    bool? isMultiChapter,
    int? chapterCount,
    List<Character>? characters,
  }) {
    return StorySettings(
      genres: genres ?? this.genres,
      length: length ?? this.length,
      mood: mood ?? this.mood,
      readingLevel: readingLevel ?? this.readingLevel,
      setting: setting ?? this.setting,
      customPrompt: customPrompt ?? this.customPrompt,
      language: language ?? this.language,
      style: style ?? this.style,
      isMultiChapter: isMultiChapter ?? this.isMultiChapter,
      chapterCount: chapterCount ?? this.chapterCount,
      characters: characters ?? this.characters,
    );
  }
}