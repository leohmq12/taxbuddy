import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../splash_screens/splash_screen3.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 75, 156, 1),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Setup',
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo/Image
              Image.asset(
                'assets/images/image2.png',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // Title
              Text(
                'Voice-Powered Tax Guidance',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  color: const Color.fromRGBO(4, 51, 119, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                'Ask questions about UK taxes using your voice or text and get clear, simple answers instantly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  color: const Color.fromRGBO(75, 85, 99, 1),
                  fontSize: 14,
                  height: 1.5,
                  decoration: TextDecoration.none,
                ),
              ),

              const Spacer(),

              // Next Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 75, 156, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Skip Button
              TextButton(
                onPressed: () {
                  print("Skip button clicked");
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.urbanist(
                    color: const Color.fromRGBO(75, 85, 99, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 34,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(160),
                      color: const Color.fromRGBO(73, 179, 205, 1),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _buildIndicatorDot(),
                  const SizedBox(width: 6),
                  _buildIndicatorDot(),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(217, 217, 217, 1),
        shape: BoxShape.circle,
      ),
    );
  }
}
