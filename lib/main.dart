import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart'; // Import AuthProvider
import 'providers/character_provider.dart';
import 'providers/story_generation_provider.dart';
import 'providers/story_provider.dart';
import 'providers/user_preferences_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart'; // Placeholder
import 'screens/characters_screen.dart'; // Placeholder
import 'screens/library_screen.dart'; // Placeholder
import 'screens/settings_screen.dart'; // Placeholder
import 'screens/story_customization_screen.dart'; // Assuming this screen exists
import 'screens/story_display_screen.dart'; // Assuming this screen exists
import 'screens/character_creation_screen.dart'; // Assuming this screen exists
import 'screens/main_navigation_screen.dart';
import 'models/character.dart'; // Assuming Character model is in models/character.dart



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserPreferencesProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => StoryGenerationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryKitchen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/characters': (context) => MainNavigationScreen(initialTab: 1),
        '/library': (context) => MainNavigationScreen(initialTab: 2),
        '/settings': (context) => MainNavigationScreen(initialTab: 3),
        '/storyCustomization': (context) => StoryCustomizationScreen(),
        '/storyDisplay': (context) => StoryDisplayScreen(),
        '/characterCreation': (context) => const CharacterCreationScreen(),
        '/characterEdit': (context) => const CharacterCreationScreen(),
      },
    );
  }
}
