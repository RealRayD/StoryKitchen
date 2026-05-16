import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterProvider = context.watch<CharacterProvider>();
    final characters = characterProvider.characters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('My Characters', style: AppStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, '/characterCreation'),
          ),
        ],
      ),
      body: characters.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return _buildCharacterCard(context, characterProvider, character, index);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_outlined, size: 80, color: AppColors.textMuted.withOpacity(0.3))
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2.seconds),
          const SizedBox(height: 24),
          Text(
            'Your cast is waiting...',
            style: AppStyles.h3.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Text(
            'Create your first character to start storytelling.',
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
            onPressed: () => Navigator.pushNamed(context, '/characterCreation'),
            child: const Text('Create New Character', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ).animate().fadeIn(),
    );
  }

  Widget _buildCharacterCard(BuildContext context, CharacterProvider provider, Character character, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppStyles.glassDecoration,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Hero(
          tag: 'char_avatar_${character.id}',
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.background,
            child: Text(character.name[0], style: AppStyles.h2.copyWith(color: AppColors.primary)),
          ),
        ),
        title: Text(character.name, style: AppStyles.h3),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _buildTag(character.gender),
              const SizedBox(width: 8),
              _buildTag('${character.age} years'),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
          onPressed: () => _confirmDelete(context, provider, character),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/characterEdit',
            arguments: character,
          );
        },
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1);
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

  void _confirmDelete(BuildContext context, CharacterProvider provider, Character character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Delete Character?', style: AppStyles.h3),
          content: Text('Are you sure you want to remove ${character.name}?', style: AppStyles.bodyMedium),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Keep', style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                provider.removeCharacter(character);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.error,
                    content: Text('${character.name} has been removed.'),
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }
}
