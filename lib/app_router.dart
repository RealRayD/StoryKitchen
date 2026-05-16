import 'package:flutter/material.dart';
import 'models/character.dart';
import 'models/story.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/story_customization_screen.dart';
import 'screens/story_display_screen.dart';
import 'screens/character_creation_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/privacy_policy_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialTab: 0));
      case '/characters':
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialTab: 1));
      case '/library':
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialTab: 2));
      case '/settings':
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen(initialTab: 3));
      case '/storyCustomization':
        return MaterialPageRoute(builder: (_) => const StoryCustomizationScreen());
      case '/storyDisplay':
        final story = settings.arguments as Story?;
        return MaterialPageRoute(builder: (_) => StoryDisplayScreen(existingStory: story));
      case '/characterCreation':
        return MaterialPageRoute(builder: (_) => const CharacterCreationScreen());
      case '/characterEdit':
        final character = settings.arguments as Character?;
        return MaterialPageRoute(
          builder: (_) => CharacterCreationScreen(character: character),
        );
      case '/help':
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case '/privacy':
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}