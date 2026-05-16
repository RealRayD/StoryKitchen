import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/character.dart';
import '../providers/character_provider.dart';
import '../providers/story_generation_provider.dart';
import '../widgets/custom_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

// Expanded Genre List (Noir removed from Genre)
final List<Map<String, dynamic>> genres = [
  {'name': 'Fantasy', 'icon': Icons.auto_stories},
  {'name': 'Sci-Fi', 'icon': Icons.rocket_launch},
  {'name': 'Mystery', 'icon': Icons.search},
  {'name': 'Adventure', 'icon': Icons.explore},
  {'name': 'Romance', 'icon': Icons.favorite},
  {'name': 'Horror', 'icon': Icons.shield_moon},
  {'name': 'Thriller', 'icon': Icons.flash_on},
  {'name': 'Comedy', 'icon': Icons.theater_comedy},
  {'name': 'Cyberpunk', 'icon': Icons.precision_manufacturing},
  {'name': 'Dystopian', 'icon': Icons.dangerous},
  {'name': 'Mythology', 'icon': Icons.temple_hindu},
];

final List<String> moods = [
  'Lighthearted', 'Suspenseful', 'Emotional', 'Humorous', 'Dark', 'Epic', 'Somber', 'Cozy'
];

final List<String> languages = [
  'English', 'Latvian', 'German', 'French', 'Spanish'
];

final List<Map<String, dynamic>> writingStyles = [
  {'name': 'Regular', 'icon': Icons.history_edu},
  {'name': 'Shakespearean', 'icon': Icons.theater_comedy},
  {'name': 'Noir', 'icon': Icons.nights_stay},
  {'name': 'Victorian', 'icon': Icons.temple_buddhist},
  {'name': 'Fairy Tale', 'icon': Icons.auto_fix_high},
  {'name': 'Cinematic', 'icon': Icons.movie},
];

class StoryCustomizationScreen extends StatefulWidget {
  const StoryCustomizationScreen({super.key});

  @override
  _StoryCustomizationScreenState createState() =>
      _StoryCustomizationScreenState();
}

class _StoryCustomizationScreenState extends State<StoryCustomizationScreen> {
  final List<String> _selectedGenres = [];
  double _storyLength = 1000;
  String? _selectedMood;
  String _selectedLanguage = 'English';
  String _selectedStyle = 'Regular';
  bool _showAdvanced = false;
  final Set<Character> _selectedCharacters = {};
  final _plotController = TextEditingController();

  final List<Map<String, dynamic>> _lengthOptions = [
    {'name': 'Flash', 'words': 300},
    {'name': 'Short', 'words': 800},
    {'name': 'Medium', 'words': 1500},
    {'name': 'Long', 'words': 3000},
    {'name': 'Epic', 'words': 5000},
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<StoryGenerationProvider>();
    _selectedGenres.addAll(provider.settings.genres);
    _storyLength = provider.settings.length.toDouble();
    _selectedMood = provider.settings.mood;
    _selectedLanguage = provider.settings.language;
    _selectedStyle = provider.settings.style;
    if (provider.settings.characters.isNotEmpty) {
      _selectedCharacters.addAll(provider.settings.characters);
    }
    _plotController.text = provider.settings.customPrompt;
  }

  @override
  void dispose() {
    _plotController.dispose();
    super.dispose();
  }

  int _getClosestLengthIndex(double words) {
    int closestIndex = 0;
    double minDiff = (words - _lengthOptions[0]['words']).abs();
    for (int i = 1; i < _lengthOptions.length; i++) {
      double diff = (words - _lengthOptions[i]['words']).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  void _generateStory() async {
    final provider = context.read<StoryGenerationProvider>();
    final newSettings = provider.settings.copyWith(
      genres: _selectedGenres.isEmpty ? ['Fantasy'] : _selectedGenres,
      length: _storyLength.toInt(),
      mood: _selectedMood ?? 'Lighthearted',
      language: _selectedLanguage,
      style: _selectedStyle,
      customPrompt: _plotController.text,
      characters: _selectedCharacters.toList(),
    );
    provider.updateSettings(newSettings);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: AppStyles.glassDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 24),
              Text('Brewing your story...', style: AppStyles.h3),
            ],
          ),
        ),
      ).animate().scale().fadeIn(),
    );

    await provider.generateStory();
    if (mounted) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/storyDisplay');
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterProvider = Provider.of<CharacterProvider>(context);
    final allCharacters = characterProvider.characters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Customize Story', style: AppStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(AppStyles.defaultPadding, 8, AppStyles.defaultPadding, 120),
        child: Column(
          children: [
            // Section 1: Genre Carousel (Compact & Premium)
            _buildSection(
              title: _selectedGenres.length > 1 ? 'Genre Mix' : 'Key Theme',
              child: _buildGenreCarousel(),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),

             // Section 2: Mood (Horizontal Scroll)
            _buildSection(
              title: 'Atmosphere',
              child: _buildHorizontalChips(
                options: moods,
                selected: _selectedMood,
                onSelected: (val) => setState(() => _selectedMood = val),
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 16),

            // Section 3: The Cast
            _buildSection(
              title: 'The Cast',
              child: _buildCharacterSelection(allCharacters),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 16),
            
            // Section 4: Advanced Toggle
            _buildAdvancedToggle(),
            if (_showAdvanced) ...[
              const SizedBox(height: 16),
              _buildSection(
                title: 'Story Mechanics',
                child: Column(
                  children: [
                    _buildLanguageSelector(),
                    const Divider(color: Colors.white10, height: 24),
                    _buildStyleSelector(),
                    const Divider(color: Colors.white10, height: 24),
                    _buildMultiChapterToggle(),
                    const Divider(color: Colors.white10, height: 24),
                    _buildLengthSlider(),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            ],
            const SizedBox(height: 16),

            // Section 5: Plot Directives
            _buildSection(
              title: 'Plot Directives',
              child: TextField(
                controller: _plotController,
                maxLines: 3,
                style: AppStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter specific plot points or leave blank...',
                  hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomButton(
          text: 'Generate Masterpiece',
          icon: Icons.auto_awesome,
          onPressed: _selectedGenres.isNotEmpty && _selectedCharacters.isNotEmpty
              ? _generateStory
              : null,
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.glassDecoration.copyWith(
        color: AppColors.cardBg.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.h3.copyWith(color: AppColors.primary, fontSize: 13, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildAdvancedToggle() {
    return InkWell(
      onTap: () => setState(() => _showAdvanced = !_showAdvanced),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 12),
                Text('Advanced Settings', style: AppStyles.bodyMedium.copyWith(color: AppColors.primary)),
              ],
            ),
            Icon(
              _showAdvanced ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreCarousel() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = _selectedGenres.contains(genre['name']);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (_selectedGenres.contains(genre['name'])) {
                  _selectedGenres.remove(genre['name']);
                } else if (_selectedGenres.length < 2) {
                  _selectedGenres.add(genre['name']);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? Colors.white24 : Colors.white10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Stack(
                     alignment: Alignment.topRight,
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(4.0),
                         child: Icon(genre['icon'], color: isSelected ? Colors.white : Colors.white70, size: 24),
                       ),
                       if (isSelected)
                         Container(
                           padding: const EdgeInsets.all(2),
                           decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                           child: Icon(Icons.check, size: 10, color: AppColors.primary),
                         ),
                     ],
                   ),
                   const SizedBox(height: 4),
                   Text(
                     genre['name'],
                     style: AppStyles.bodySmall.copyWith(
                       color: isSelected ? Colors.white : Colors.white70,
                       fontSize: 10,
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalChips({
    required List<String> options,
    required String? selected,
    required Function(String) onSelected,
  }) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final opt = options[index];
          final isSelected = selected == opt;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (s) => onSelected(opt),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.cardBg.withOpacity(0.5),
              labelStyle: AppStyles.bodySmall.copyWith(color: isSelected ? Colors.white : Colors.white38),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: isSelected ? Colors.white24 : Colors.white10),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStyleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Writing Style', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: Colors.white70)),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: writingStyles.length,
            itemBuilder: (context, index) {
              final style = writingStyles[index];
              final isSelected = _selectedStyle == style['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedStyle = style['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 85,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.white10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(style['icon'], color: isSelected ? AppColors.primary : Colors.white60, size: 20),
                      const SizedBox(height: 6),
                      Text(style['name'], style: AppStyles.bodySmall.copyWith(fontSize: 9, color: isSelected ? Colors.white : Colors.white60)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Language', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: Colors.white70)),
        const SizedBox(height: 12),
        _buildHorizontalChips(
          options: languages,
          selected: _selectedLanguage,
          onSelected: (val) => setState(() => _selectedLanguage = val),
        ),
      ],
    );
  }

  Widget _buildMultiChapterToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Multi-Chapter Story', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 12)),
                Text('Generate the story piece by piece', style: AppStyles.bodySmall.copyWith(fontSize: 10, color: Colors.white38)),
              ],
            ),
            Switch(
              value: context.read<StoryGenerationProvider>().settings.isMultiChapter,
              activeColor: AppColors.primary,
              onChanged: (val) {
                final provider = context.read<StoryGenerationProvider>();
                int newCount = provider.settings.chapterCount;
                if (val && newCount < 2) newCount = 2; 
                provider.updateSettings(provider.settings.copyWith(
                  isMultiChapter: val,
                  chapterCount: newCount,
                ));
                setState(() {});
              },
            ),
          ],
        ),
        if (context.read<StoryGenerationProvider>().settings.isMultiChapter) ...[
          const SizedBox(height: 12),
          Text('Chapter Count: ${context.read<StoryGenerationProvider>().settings.chapterCount}', 
              style: AppStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          Slider(
            value: context.read<StoryGenerationProvider>().settings.chapterCount.toDouble(),
            min: 2,
            max: 9,
            divisions: 7,
            activeColor: AppColors.primary,
            onChanged: (val) {
              final provider = context.read<StoryGenerationProvider>();
              provider.updateSettings(provider.settings.copyWith(chapterCount: val.toInt()));
              setState(() {});
            },
          ),
        ],
      ],
    );
  }

  Widget _buildLengthSlider() {
    int currentIndex = _getClosestLengthIndex(_storyLength);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Word Count', style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: Colors.white70)),
        Slider(
          value: currentIndex.toDouble(),
          min: 0,
          max: 4,
          divisions: 4,
          activeColor: AppColors.primary,
          onChanged: (double value) {
            setState(() => _storyLength = _lengthOptions[value.toInt()]['words'].toDouble());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _lengthOptions.map((opt) {
            final isSelected = _lengthOptions.indexOf(opt) == currentIndex;
            return Text(
              opt['name'],
              style: AppStyles.bodySmall.copyWith(color: isSelected ? AppColors.primary : Colors.white60),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCharacterSelection(List<Character> allCharacters) {
    if (allCharacters.isEmpty) {
      return Center(child: Text('No characters found.', style: AppStyles.bodySmall));
    }

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCharacters.length,
        itemBuilder: (context, index) {
          final char = allCharacters[index];
          final isSelected = _selectedCharacters.contains(char);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) _selectedCharacters.remove(char);
                else _selectedCharacters.add(char);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.cardBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.white10, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isSelected ? AppColors.primary : AppColors.background,
                    child: Text(char.name[0], style: AppStyles.h3.copyWith(fontSize: 16)),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(char.name, style: AppStyles.bodySmall.copyWith(fontSize: 9), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
