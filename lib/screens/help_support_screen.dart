import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Help & Support', style: AppStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Frequently Asked Questions',
              [
                _buildFaqItem('How do I generate a story?', 'Select a genre, length, and mood on the customization screen, then press "Generate Masterpiece".'),
                _buildFaqItem('What are Multi-Chapter stories?', 'These are longer stories where you can generate chapters one by one, allowing the AI to maintain a complex plot.'),
                _buildFaqItem('Can I edit my characters?', 'Yes! Go to the Characters tab and click on any character to edit their traits or origin story.'),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Contact Us',
              [
                _buildContactItem(Icons.email_outlined, 'Email Support', 'support@storykitchen.ai'),
                _buildContactItem(Icons.bug_report_outlined, 'Report a Bug', 'Report an issue to our developers.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.h3.copyWith(color: AppColors.primary)),
        const SizedBox(height: 16),
        Container(
          decoration: AppStyles.glassDecoration,
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
      iconColor: AppColors.primary,
      collapsedIconColor: AppColors.textSecondary,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: AppStyles.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppStyles.bodyLarge),
      subtitle: Text(subtitle, style: AppStyles.bodySmall),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () {},
    );
  }
}
