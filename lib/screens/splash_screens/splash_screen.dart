import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splash_screens/splash_screen1.dart'; // Your existing onboarding screen
import '../splash_screens/login_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnUserStatus(); // ✅ Start checking user status
  }

  /// ✅ **Check if user is opening the app for the first time**
  Future<void> _navigateBasedOnUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true; // Default to true

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        if (isFirstTime) {
          // 🔹 Show onboarding, then set flag to false
          prefs.setBool('isFirstTime', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()), // Your existing onboarding screen
          );
        } else {
          // 🔹 User has already seen onboarding, go to LoginScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 75, 156, 0.85),
          image: DecorationImage(
            image: AssetImage('assets/images/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/image1.png', width: 250),
              const SizedBox(height: 20),

              // Title with Oak Sans
              Text(
                'Tax Buddy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'OakSans', // Using Oak Sans
                ),
              ),
              const SizedBox(height: 10),

              // Main Logo Text (Jost remains the same)
              Text(
                'AA&T',
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Tagline
              Text(
                'Aces Accounts & Taxation Ltd',
                textAlign: TextAlign.center,
                style: GoogleFonts.jost(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
