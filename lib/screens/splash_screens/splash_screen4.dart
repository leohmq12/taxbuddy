import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../splash_screens/login_screen.dart'; // Import your login screen

class FourthScreen extends StatelessWidget {
  const FourthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004B9C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Setup',
          style: GoogleFonts.urbanist(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: _buildMainContent(context),
    );
  }

  /// **Main Content**
  Widget _buildMainContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/image5.png',
          width: 140,
          height: 140,
        ),
        const SizedBox(height: 40),
        const Text(
          'VAT & Deadline Reminders',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF043377),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Never miss important UK tax dates with customizable alerts and notifications.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 40),
        _buildGetStartedButton(context),
        const Spacer(),
        _buildBottomBar(),
      ],
    );
  }

  /// **"Get Started" Button**
  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004B9C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        minimumSize: const Size(343, 50),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      child: Text(
        'Get Started',
        style: GoogleFonts.urbanist(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// **Bottom Bar with Indicators**
  Widget _buildBottomBar() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIndicatorDot(false),
            _buildIndicatorDot(false),
            _buildIndicatorDot(true), // Last one should be active
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  /// **Indicator Dot**
  Widget _buildIndicatorDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 34 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF49B3CD) : const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(160),
      ),
    );
  }
}
