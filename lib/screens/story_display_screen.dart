import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/story.dart';
import '../providers/story_generation_provider.dart';
import '../providers/story_provider.dart';
import '../widgets/custom_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class StoryDisplayScreen extends StatefulWidget {
  final Story? existingStory;

  const StoryDisplayScreen({super.key, this.existingStory});

  @override
  _StoryDisplayScreenState createState() => _StoryDisplayScreenState();
}

class _StoryDisplayScreenState extends State<StoryDisplayScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  double _fontSize = 18.0;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });

    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() => _isSpeaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppColors.error, content: Text("TTS Error: $msg")),
      );
    });
  }

  Future<void> _speak(String text) async {
    if (!_isSpeaking) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> _stop() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    }
  }

  void _saveStory(BuildContext context, Story story) async {
    // If the story has an error ID, generate a proper timestamp ID instead
    String storyId = story.id == 'error' ? DateTime.now().millisecondsSinceEpoch.toString() : story.id;
    final storyToSave = Story(
      id: storyId,
      userId: story.userId,
      title: story.title,
      content: story.content,
      genres: story.genres,
      length: story.length,
      mood: story.mood,
      featuredCharacters: story.featuredCharacters,
      createdDate: DateTime.now(),
    );

    try {
      await context.read<StoryProvider>().addStory(storyToSave);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Story saved to your library!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _shareStory(BuildContext context, Story story) {
    SharePlus.instance.share(
      ShareParams(
        text: '"${story.title}"\n\n${story.content}',
        subject: 'A story from StoryKitchen: ${story.title}',
      ),
    );
  }

  void _regenerateStory(BuildContext context) async {
    _stop();
    final provider = context.read<StoryGenerationProvider>();
    
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
              Text('Brewing a new version...', style: AppStyles.h3),
            ],
          ),
        ),
      ),
    );

    await provider.generateStory();
    if (mounted) Navigator.pop(context);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story regenerated!'), backgroundColor: AppColors.primary),
      );
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyGenerationProvider = context.watch<StoryGenerationProvider>();
    final story = widget.existingStory ?? storyGenerationProvider.generatedStory;
    final bool isFromLibrary = widget.existingStory != null;

    return PopScope(
      canPop: !_isSpeaking,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) await _stop();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context, story),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    if (story == null && storyGenerationProvider.isLoading)
                      const Center(child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: CircularProgressIndicator(),
                      ))
                    else if (story == null)
                      _buildErrorState()
                    else
                      _buildStoryReader(story.content),
                    
                    // Multi-chapter progression
                    if (storyGenerationProvider.hasMoreChapters && !isFromLibrary) ...[
                      const SizedBox(height: 32),
                      _buildNextChapterButton(context, storyGenerationProvider),
                    ],
                    
                    const SizedBox(height: 80), // Space for bottom actions
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: story != null ? _buildControlPanel(context, story, isFromLibrary) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Story? story) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(
          story?.title ?? 'Story',
          style: AppStyles.h2.copyWith(fontSize: 18),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.05), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isSpeaking ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded, 
                color: AppColors.primary),
          iconSize: 32,
          onPressed: () {
            if (story != null) {
              _isSpeaking ? _stop() : _speak(story.content);
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStoryReader(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: MarkdownBody(
        data: content,
        styleSheet: MarkdownStyleSheet(
          p: AppStyles.storyText.copyWith(fontSize: _fontSize),
          em: AppStyles.storyText.copyWith(
            fontSize: _fontSize,
            fontStyle: FontStyle.italic,
            color: AppColors.textPrimary.withOpacity(0.6), // Muted italics for narration
          ),
          strong: AppStyles.storyText.copyWith(
            fontSize: _fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildNextChapterButton(BuildContext context, StoryGenerationProvider provider) {
    if (provider.isLoading) {
      return Center(
        child: Column(
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 12),
            Text('Brewing next chapter...', style: AppStyles.bodySmall.copyWith(color: AppColors.primary)),
          ],
        ),
      );
    }

    return Center(
      child: OutlinedButton.icon(
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: Text('Generate Chapter ${provider.currentChapter + 1}', 
              style: const TextStyle(fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => provider.generateNextChapter(),
      ).animate().scale(delay: 200.ms),
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        const Icon(Icons.error_outline, size: 60, color: AppColors.error),
        const SizedBox(height: 16),
        Text('The kitchen ran out of ingredients.', style: AppStyles.h3),
        const SizedBox(height: 8),
        Text('Failed to find your story.', style: AppStyles.bodyMedium),
        const SizedBox(height: 32),
        CustomButton(text: 'Go Back', onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildControlPanel(BuildContext context, Story story, bool isFromLibrary) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFromLibrary) ...[
            _buildActionButton(Icons.save_alt_rounded, 'Save', () => _saveStory(context, story)),
            _buildDivider(),
            _buildActionButton(Icons.refresh_rounded, 'Retry', () => _regenerateStory(context)),
            _buildDivider(),
          ],
          _buildActionButton(Icons.share_rounded, 'Share', () => _shareStory(context, story)),
          _buildDivider(),
          _buildFontSizeTrigger(),
        ],
      ),
    ).animate().slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(height: 2),
            Text(label, style: AppStyles.bodySmall.copyWith(fontSize: 10, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeTrigger() {
    return PopupMenuButton<double>(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.text_fields_rounded, size: 20, color: Colors.white),
          const SizedBox(height: 2),
          Text('Size', style: AppStyles.bodySmall.copyWith(fontSize: 10, color: Colors.white70)),
        ],
      ),
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (val) => setState(() => _fontSize = val),
      itemBuilder: (context) => [14, 18, 22, 26].map((size) => PopupMenuItem(
        value: size.toDouble(),
        child: Text('Size $size', style: AppStyles.bodyMedium.copyWith(
          color: _fontSize == size ? AppColors.primary : Colors.white,
          fontWeight: _fontSize == size ? FontWeight.bold : FontWeight.normal,
        )),
      )).toList(),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.white10,
    );
  }
}
