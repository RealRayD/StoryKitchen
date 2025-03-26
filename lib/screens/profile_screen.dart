import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: AppStyles.headline1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/profile_placeholder.png',
              ),
            ),
            const SizedBox(height: 24),
            Text('John Doe', style: AppStyles.headline1.copyWith(fontSize: 24)),
            Text('john.doe@example.com', style: AppStyles.bodyText),
            const SizedBox(height: 32),
            _buildProfileItem(Icons.history, 'My Stories'),
            _buildProfileItem(Icons.favorite, 'Favorites'),
            _buildProfileItem(Icons.settings, 'Settings'),
            const Spacer(),
            CustomButton(
              text: 'Logout',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(text, style: AppStyles.bodyText),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Handle tap for each profile item
      },
    );
  }
}
