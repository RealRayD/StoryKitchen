import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _signOut(BuildContext context) async {}
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
        appBar: AppBar(
        title: const Text('StoryKitchen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(context),
              const SizedBox(height: 20),
              _buildGenerateButton(context),
              const SizedBox(height: 30),
              _buildMyCharactersSection(),
              _buildMyLibrarySection(),
            ],
          ),
        ),
    ); // Added missing closing brace for build method
  }

  Widget _buildGreeting(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    String displayName = user?.email ?? "Guest"; // Use email as display name for now
    return Text(
      'Hi, $displayName! (from AuthProvider)',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
    return CustomButton( // Using the custom button widget
      text: 'Generate Story',
      onPressed: () {
        Navigator.pushNamed(context, '/storyCustomization');
      },
    );
  }

  Widget _buildMyCharactersSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Text('My Characters (Placeholder)'),
    );
  }

  Widget _buildMyLibrarySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Text('My Library (Placeholder)'),
    );
  }
}