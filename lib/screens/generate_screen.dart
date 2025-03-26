import 'package:flutter/material.dart';
import '../../constants/app_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _genre = '';
  String _character = '';
  String _setting = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Story', style: AppStyles.headline1)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                  label: 'Genre (e.g., Fantasy, Sci-Fi)',
                  onSaved: (value) => _genre = value ?? '',
                  ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Main Character',
                onSaved: (value) => _character = value ?? '',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Setting/World',
                maxLines: 3,
                onSaved: (value) => _setting = value ?? '',
              ),
              
              
              
              
              
              
              const SizedBox(height: 24),
              CustomButton(text: 'Generate Story', onPressed: _generateStory),
            ],
          ),
        ),
      ),
    );
  }

  void _generateStory() {
    print("Form Key State: ${_formKey.currentState}");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
        print("Genre: $_genre");
        print("Character: $_character");
        print("Setting: $_setting");
      // TODO: Add story generation logic





      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Generating your story...')));
    }
  }
}
