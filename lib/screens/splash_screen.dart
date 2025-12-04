import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:stray_haven/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // --- NEW LOGIC: CHECK LOGIN STATUS ---
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // User is ALREADY logged in -> Go straight to Home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // No user -> Go to Welcome Screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      }
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. The Logo
            Image.asset(
              'assets/pictures/stray_haven_logogif.gif',
              width: 300,
              height: 300,
            ),

            // 2. The Title & Slogan
            Transform.translate(
              offset: const Offset(0, -30),
              child: const Column(
                children: [
                  Text(
                    'STRAY HAVEN',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'CalliCat',
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Turning Stray Lives into Heartfelt Homes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontFamily: 'CalliCat',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}