import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart'; // Import the starting screen

void main() async {
  // 1. Initialize Flutter Engine
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Firebase
  await Firebase.initializeApp(); 
  
  // 3. Run the App
  runApp(const StrayHavenApp());
}

class StrayHavenApp extends StatelessWidget {
  const StrayHavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stray Haven',
      debugShowCheckedModeBanner: false,
      
      // Global Theme Settings
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        scaffoldBackgroundColor: const Color(0xFFFFC857), // Your signature Orange background
        useMaterial3: true,
      ),
      
      // The Starting Point -> Goes to Splash Screen
      home: const SplashScreen(), 
    );
  }
}