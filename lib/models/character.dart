class Character {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String backgroundStory;
  final String gender;
  final List<String> personality;

  Character({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.backgroundStory,
    required this.gender,
    required this.personality,
  });

  Character copyWith({
    String? id,
    String? userId,
    String? name,
    int? age,
    String? backgroundStory,
    String? gender,
    List<String>? personality,
  }) {
    return Character(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      backgroundStory: backgroundStory ?? this.backgroundStory,
      gender: gender ?? this.gender,
      personality: personality ?? this.personality,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'backgroundStory': backgroundStory,
      'gender': gender,
      'personality': personality,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      backgroundStory: map['backgroundStory'] ?? '',
      gender: map['gender'] ?? '',
      personality: List<String>.from(map['personality'] ?? []),
    );
  }
}