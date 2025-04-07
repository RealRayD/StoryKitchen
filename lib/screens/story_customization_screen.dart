import 'package:flutter/material.dart';
import 'package:myapp/providers/story_generation_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/story_display_screen.dart';

final List<Map<String, dynamic>> genres = [
  {'name': 'Fantasy', 'icon': Icons.book},
  {'name': 'Sci-Fi', 'icon': Icons.book},
  {'name': 'Mystery', 'icon': Icons.book},
  {'name': 'Adventure', 'icon': Icons.book},
  {'name': 'Romance', 'icon': Icons.book},
  {'name': 'Historical Fiction', 'icon': Icons.book},
  {'name': 'Thriller', 'icon': Icons.book},
  {'name': 'Children\'s Literature', 'icon': Icons.book},
];

final List<String> moods = [
  'Adventure',
  'Emotional',
  'Humorous',
  'Mysterious',
  'Dark',
];


class StoryCustomizationScreen extends StatefulWidget {
  const StoryCustomizationScreen({Key? key}) : super(key: key);

  @override
  _StoryCustomizationScreenState createState() => _StoryCustomizationScreenState();
}

class _StoryCustomizationScreenState extends State<StoryCustomizationScreen> {
  String? _selectedMood;
  String? _selectedGenre;
  String? _selectedReadingLevel;
  // Add state variables for customization options here
  double _storyLength = 1000;

  void _selectReadingLevel(String level) {
    setState(() {
      _selectedReadingLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Customize Your Story'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add customization sections here (Genre, Length, Mood, etc.)
            const Center(
              child: Text(
                'Genre Selection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Genre',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value;
                });
                final provider =
                    context.read<StoryGenerationProvider>();
                final newSettings =
                    provider.settings.copyWith(genre: value);
                provider.updateSettings(newSettings);
              },
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Story Length',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Slider(
              value: _storyLength,
              min: 300,
              max: 1500,
              divisions: 12,
              label: null,
              onChanged: (double value) {
                setState(() {
                  _storyLength = value;
                  final provider =
                      context.read<StoryGenerationProvider>();
                  final newSettings = provider.settings.copyWith(
                      length: _storyLength
                          .toInt()); // Assuming length is an integer in StorySettings
                  provider.updateSettings(newSettings);
                });
              },
            ),
            Text('Approximate word count: ${_storyLength.round()}'),
            // Placeholder for story length slider
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Mood & Tone',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: 8.0,
                children: moods.map((mood) {
                  return ChoiceChip(
                    label: Text(mood),
                    selected: _selectedMood == mood,
                    onSelected: (bool selected) {
                      final provider =
                          context.read<StoryGenerationProvider>();
                      final newSettings = provider.settings
                          .copyWith(mood: selected ? mood : '');
                      provider.updateSettings(newSettings);

                      setState(() {
                        _selectedMood = selected ? mood : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Reading Level',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: 8.0,
                children: ['Children', 'Young Adult', 'Adult'].map((level) {
                  return ChoiceChip(
                    label: Text(level),
                    selected: _selectedReadingLevel == level,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedReadingLevel = selected ? level : null;
                      });
                      final provider = context.read<StoryGenerationProvider>();
                      final newSettings = provider.settings
                          .copyWith(readingLevel: selected ? level : '');
                      provider.updateSettings(newSettings);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Characters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Placeholder for character selection
            const SizedBox(height: 20),
            const Text('Setting options not yet implemented.'),
            // Placeholder for setting options
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<StoryGenerationProvider>().generateStory();
                  Navigator.pushNamed(context, '/storyDisplay');
                },
                child: const Text('Generate Story'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingLevelOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReadingLevelOption({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(border: Border.all(color: isSelected ? Colors.blue : Colors.grey), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.blue : Colors.grey)),
      ),
    );
  }
}