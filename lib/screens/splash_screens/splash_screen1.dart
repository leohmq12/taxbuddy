import 'package:flutter/material.dart';
import '../splash_screens/splash_screen2.dart'; // Import the next screen

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(6.123234262925839e-17, 1),
            end: Alignment(-1, 6.123234262925839e-17),
            colors: [
              Color.fromRGBO(73, 179, 205, 1),
              Color.fromRGBO(0, 75, 156, 1),
            ],
          ),
        ),
        child: Column(
          children: [
            // Image
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Container(
                width: 340,
                height: 340,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/image4.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),

            // Title and Subtitle
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Text(
                    'Tax Buddy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OakSans',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamilyFallback: ['Times New Roman'],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your AI Tax Assistant from Aces Accounts',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'OakSans',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'and Taxation Ltd',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'OakSans',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Spacer to push the button and text to the bottom
            const Spacer(),

            // Get Started Button (Now Functional)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to SplashScreen2
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(73, 179, 205, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OakSans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Terms & Privacy Policy
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              child: Text(
                'By continuing, you agree to our Terms and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'OakSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
