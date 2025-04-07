class Character {
  final String id;
  final String name;
  final String image;
  final int age;
  final List<String> personalityTraits;
  final String background;
  final DateTime createdDate;
  final DateTime modifiedDate;

  Character({
    required this.id,
    required this.name,
    this.image = '',
    this.age = 0,
    this.personalityTraits = const [],
    this.background = '',
  })  : createdDate = DateTime.now(),
        modifiedDate = DateTime.now();


}