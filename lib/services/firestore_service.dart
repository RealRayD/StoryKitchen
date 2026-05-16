import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/character.dart';
import '../models/story.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance; // Firestore database
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  CollectionReference get _charactersRef => _db.collection('characters'); // Characters collection
  CollectionReference get _storiesRef => _db.collection('stories');       // Stories collection

  // Streams real-time character updates for a given user
  Stream<List<Character>> streamCharacters(String uid) {
    return _charactersRef
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Character.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Saves or updates a character, stamping the current user's ID
  Future<void> saveCharacter(Character character) async {
    final uid = _currentUserId;
    if (uid == null) throw Exception('User not logged in');
    final charToSave = character.copyWith(userId: uid);
    await _charactersRef.doc(charToSave.id).set(charToSave.toMap());
  }

  Future<void> deleteCharacter(String characterId) async {
    await _charactersRef.doc(characterId).delete();
  }

  // Streams real-time story updates for a given user
  Stream<List<Story>> streamStories(String uid) {
    return _storiesRef
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Story.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Saves or updates a story, stamping the current timestamp
  Future<void> saveStory(Story story) async {
    final uid = _currentUserId;
    if (uid == null) throw Exception('User not logged in');

    final storyToSave = Story(
      id: story.id,
      userId: uid,
      title: story.title,
      content: story.content,
      genres: story.genres,
      length: story.length,
      mood: story.mood,
      featuredCharacters: story.featuredCharacters,
      createdDate: story.createdDate,
      modifiedDate: DateTime.now(), // always update modification time on save
      read: story.read,
      progress: story.progress,
    );

    await _storiesRef.doc(storyToSave.id).set(storyToSave.toMap());
  }

  Future<void> deleteStory(String storyId) async {
    await _storiesRef.doc(storyId).delete();
  }
}
