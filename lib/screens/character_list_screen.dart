import 'package:flutter/material.dart';
import 'character_creation_screen.dart'; // Import the CharacterCreationScreen

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Characters'),
      ),
      body: const Center(
        child: Text('Character list will be displayed here...'), // Placeholder
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/characterCreation');
          // Use Navigator.pushNamed to navigate to the CharacterCreationScreen
          // Add navigation to character creation screen Navigator.pushNamed(context, '/characterCreation');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}