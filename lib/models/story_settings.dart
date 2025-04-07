class StorySettings {
  String genre;
  int length;
  String mood;
  String readingLevel;
  String setting;
  // Add other story settings attributes here

  StorySettings({
    this.genre = '',
    this.length = 1000,
    this.mood = '',
    this.readingLevel = '',
    this.setting = '',
    // Initialize other attributes here
  });

  StorySettings copyWith({
    String? genre,
    int? length,
    String? mood,
    String? readingLevel,
    String? setting,
  }) {
    return StorySettings(
        genre: genre ?? this.genre, length: length ?? this.length, mood: mood ?? this.mood, readingLevel: readingLevel ?? this.readingLevel, setting: setting ?? this.setting);
  }
}