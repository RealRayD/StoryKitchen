import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Privacy Policy', style: AppStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppStyles.glassDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParagraph('Everything you create in StoryKitchen is personal to you. We are committed to protecting your privacy and ensuring your stories remain your own.'),
              
              _buildSubheader('Data Collection'),
              _buildParagraph('We collect minimal data to provide our services, including your email for account synchronization and your character/story data stored securely in Firebase.'),
              
              _buildSubheader('AI Usage'),
              _buildParagraph('Your story prompts are processed by the Gemini API to generate creative content. No personal information is shared with the AI beyond the context of your story settings.'),
              
              _buildSubheader('Your Rights'),
              _buildParagraph('You have the right to access, export, or delete your data at any time from within the app settings.'),
              
              const SizedBox(height: 24),
              Text('Last Updated: April 2026', style: AppStyles.bodySmall.copyWith(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubheader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(text, style: AppStyles.h3.copyWith(color: AppColors.primary, fontSize: 16)),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(text, style: AppStyles.bodyMedium.copyWith(height: 1.5));
  }
}
