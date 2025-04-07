import 'package:flutter/material.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({Key? key}) : super(key: key);

  @override
  _CharacterCreationScreenState createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _backgroundController = TextEditingController();
  // Add controllers for other fields like personality traits

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Character'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Add form fields for character details
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Personality Traits (Not implemented)'), // Placeholder
              // Replace with actual multi-select or chips widget
              const SizedBox(height: 20),
              TextFormField(
                controller: _backgroundController,
                decoration: const InputDecoration(
                  labelText: 'Background Story',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a background story';
                  }
                  return null;
                },
              ),

              // Add form fields (age, personality, background, etc.)

              // Add personality traits (multi-select or chips)

              const SizedBox(height: 20),
              const Text('Avatar Customization (Not implemented)'), // Placeholder
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add character saving logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Character saved!')),
                    );
                  }
                },
                child: const Text('Save Character'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}