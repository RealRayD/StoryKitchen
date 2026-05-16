import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import '../providers/character_provider.dart';
import '../providers/story_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppStyles.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroCard(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    context,
                    title: 'My Characters',
                    onSeeAll: () => Navigator.pushNamed(context, '/characters'),
                  ),
                  const SizedBox(height: 16),
                  _buildCharactersList(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    context,
                    title: 'Recent Stories',
                    onSeeAll: () => Navigator.pushNamed(context, '/library'),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentStoriesList(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final displayName = user?.email?.split('@')[0] ?? "Writer";

    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(
          'Hi, $displayName',
          style: AppStyles.h2.copyWith(fontSize: 20),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.1), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            backgroundColor: AppColors.cardBg,
            child: IconButton(
              icon: const Icon(Icons.logout, size: 20, color: AppColors.textSecondary),
              onPressed: () => context.read<AuthProvider>().signOut(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            'Ready for a new adventure?',
            style: AppStyles.h2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a unique story with your favorite characters using AI.',
            style: AppStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => Navigator.pushNamed(context, '/storyCustomization'),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Start Writing', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(delay: 200.ms);
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppStyles.h3),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            'See All',
            style: AppStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildCharactersList(BuildContext context) {
    final characters = context.watch<CharacterProvider>().characters;

    if (characters.isEmpty) {
      return _buildEmptyState('No characters yet', () => Navigator.pushNamed(context, '/characterCreation'));
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: characters.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddCharacterButton(context);
          }
          final char = characters[index - 1];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.cardBg,
                  child: Text(char.name[0], style: AppStyles.h2.copyWith(fontSize: 24)),
                ),
                const SizedBox(height: 8),
                Text(
                  char.name,
                  style: AppStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
    );
  }

  Widget _buildAddCharacterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/characterCreation'),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.glassBg,
              child: const Icon(Icons.add, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text('Create', style: AppStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentStoriesList(BuildContext context) {
    final stories = context.watch<StoryProvider>().stories;

    if (stories.isEmpty) {
      return _buildEmptyState('No stories yet', () => Navigator.pushNamed(context, '/storyCustomization'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stories.take(3).length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/storyDisplay', arguments: story),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: AppStyles.glassDecoration,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.book, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story.title, style: AppStyles.h3.copyWith(fontSize: 16)),
                      Text(
                        '${story.content.split(' ').take(10).join(' ')}...',
                        style: AppStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildEmptyState(String message, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: AppStyles.glassDecoration.copyWith(
          border: Border.all(color: AppColors.textMuted.withOpacity(0.2), style: BorderStyle.none),
          color: AppColors.cardBg.withOpacity(0.5),
        ),
        child: Column(
          children: [
            Icon(Icons.edit_note, color: AppColors.textMuted.withOpacity(0.5), size: 48),
            const SizedBox(height: 12),
            Text(message, style: AppStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}