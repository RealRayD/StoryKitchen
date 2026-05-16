import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/story_provider.dart';
import '../models/story.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We use context.watch to rebuild when stories change
    final storyProvider = context.watch<StoryProvider>();
    final stories = storyProvider.stories;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('My Library', style: AppStyles.h2),
      ),
      body: _buildBody(context, stories),
    );
  }

  Widget _buildBody(BuildContext context, List<Story> stories) {
    if (stories.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildStoryCard(context, story, index);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 80, color: AppColors.textMuted.withOpacity(0.3))
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2.seconds),
          const SizedBox(height: 24),
          Text(
            'Your bookshelf is empty',
            style: AppStyles.h3.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Text(
            'The stories you generate will appear here.',
            style: AppStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pushNamed(context, '/storyCustomization'),
            child: const Text('Generate First Story', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Text(
            '(If you just saved a story, make sure your Firebase Rules are published)',
            style: AppStyles.bodySmall.copyWith(fontSize: 10),
          ),
        ],
      ).animate().fadeIn(),
    );
  }

  Widget _buildStoryCard(BuildContext context, Story story, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppStyles.glassDecoration,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.auto_stories, color: AppColors.primary),
        ),
        title: Text(story.title, style: AppStyles.h3),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              story.content.length > 60 
                  ? '${story.content.substring(0, 60)}...' 
                  : story.content,
              style: AppStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag(story.genres.isNotEmpty ? story.genres.join(', ') : "Fantasy"),
                const SizedBox(width: 8),
                _buildTag('${story.length} words'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
          onPressed: () => _confirmDelete(context, story),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/storyDisplay',
            arguments: story,
          );
        },
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
  }

  void _confirmDelete(BuildContext context, Story story) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text('Delete Story?', style: AppStyles.h3),
        content: Text('Are you sure you want to delete "${story.title}" permanently?', style: AppStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              context.read<StoryProvider>().deleteStory(story.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.glassBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppStyles.bodySmall.copyWith(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}