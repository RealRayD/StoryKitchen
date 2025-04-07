class Story {
  final String id;
  final String title;
  final String content;
  final String genre;
  final int length;
  final String mood;
  final List<String> featuredCharacters;
  final DateTime createdDate;
  final DateTime modifiedDate;
  final bool read;
  final double progress;

  Story({
    required this.id,
    required this.title,
    required this.content,
    this.genre = '', // Provide a default value
    this.length = 0, // Provide a default value
    this.mood = '', // Provide a default value
    this.featuredCharacters = const [], // Provide a default value
    DateTime? createdDate,
    DateTime? modifiedDate,
    this.read = false,
    this.progress = 0.0,
  })  : createdDate = createdDate ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

}