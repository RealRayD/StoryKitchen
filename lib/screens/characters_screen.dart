import 'package:flutter/material.dart';
import 'package:myapp/screens/character_list_screen.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Characters')),
      body: const Column(
        children: [Text("Characters Screen Content"), CharacterListScreen()],
      ),
    );
  }
}