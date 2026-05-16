import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Settings', style: AppStyles.h2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileSection(context),
            const SizedBox(height: 24),
            _buildSettingsGroup('App Settings', [
              _buildSettingItem(
                Icons.notifications_none_outlined, 
                'Notifications', 
                _notificationsEnabled ? 'On' : 'Off',
                trailing: Switch(
                  value: _notificationsEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val ? 'Notifications enabled' : 'Notifications disabled'),
                        backgroundColor: val ? AppColors.success : AppColors.textMuted,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
              _buildSettingItem(Icons.color_lens_outlined, 'Appearance', 'Dark Mode Enabled'),
              _buildSettingItem(Icons.language_outlined, 'Language', 'English'),
            ]),
            const SizedBox(height: 24),
            _buildSettingsGroup('About', [
              _buildSettingItem(Icons.info_outline_rounded, 'Version', '1.0.0'),
              _buildSettingItem(
                Icons.help_outline_rounded, 
                'Help & Support', 
                null,
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),
              _buildSettingItem(
                Icons.privacy_tip_outlined, 
                'Privacy Policy', 
                null,
                onTap: () => Navigator.pushNamed(context, '/privacy'),
              ),
            ]),
            const SizedBox(height: 40),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final displayName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.glassDecoration,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Text(
              displayName[0].toUpperCase(),
              style: AppStyles.h2.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: AppStyles.h3),
                Text(user?.email ?? '', style: AppStyles.bodySmall),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showEditNameDialog(context, authProvider, displayName),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.glassBg, shape: BoxShape.circle),
              child: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  void _showEditNameDialog(BuildContext context, AuthProvider provider, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text('Edit Name', style: AppStyles.h3),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: AppStyles.bodySmall,
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.glassBg)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await provider.updateDisplayName(controller.text);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text('Save', style: AppStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: AppStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        Container(
          decoration: AppStyles.glassDecoration,
          child: Column(children: items),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildSettingItem(IconData icon, String title, String? subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(title, style: AppStyles.bodyLarge),
      subtitle: subtitle != null ? Text(subtitle, style: AppStyles.bodySmall) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColors.error.withOpacity(0.1),
        ),
        onPressed: () => context.read<AuthProvider>().signOut(),
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: Text('Logout', style: AppStyles.h3.copyWith(color: AppColors.error)),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}