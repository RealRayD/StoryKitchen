class Story {
  final String id;
  final String userId;
  final String title;
  final String content;
  final List<String> genres;
  final int length;
  final String mood;
  final List<String> featuredCharacters;
  final DateTime createdDate;
  final DateTime modifiedDate;
  final bool read;
  final double progress;

  Story({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.genres = const [],
    this.length = 0,
    this.mood = '',
    this.featuredCharacters = const [],
    DateTime? createdDate,
    DateTime? modifiedDate,
    this.read = false,
    this.progress = 0.0,
  })  : createdDate = createdDate ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'genres': genres,
      'length': length,
      'mood': mood,
      'featuredCharacters': featuredCharacters,
      'createdDate': createdDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'read': read,
      'progress': progress,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      genres: map['genres'] is List 
          ? List<String>.from(map['genres']) 
          : (map['genres'] != null ? [map['genres'].toString()] : (map['genre'] != null ? [map['genre'].toString()] : [])),
      length: map['length'] ?? 0,
      mood: map['mood'] ?? '',
      featuredCharacters: List<String>.from(map['featuredCharacters'] ?? []),
      createdDate: map['createdDate'] != null 
          ? DateTime.parse(map['createdDate']) 
          : DateTime.now(),
      modifiedDate: map['modifiedDate'] != null 
          ? DateTime.parse(map['modifiedDate']) 
          : DateTime.now(),
      read: map['read'] ?? false,
      progress: (map['progress'] ?? 0.0).toDouble(),
    );
  }

  Story copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? genres,
    int? length,
    String? mood,
    List<String>? featuredCharacters,
    DateTime? createdDate,
    DateTime? modifiedDate,
    bool? read,
    double? progress,
  }) {
    return Story(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      genres: genres ?? this.genres,
      length: length ?? this.length,
      mood: mood ?? this.mood,
      featuredCharacters: featuredCharacters ?? this.featuredCharacters,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      read: read ?? this.read,
      progress: progress ?? this.progress,
    );
  }
}