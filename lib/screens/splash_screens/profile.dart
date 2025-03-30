import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taxbuddy/backend/settings/theme_provider.dart';
import '../splash_screens/home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedEmploymentType = "Self-Employed";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004B9C),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home'); // Replace with your HomeScreen route
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/image1.png'),
                radius: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "Your Profile",
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tax Profile Section
            Text(
              "Tax Profile",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'OakSans',
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Color(0xFF49B3CD) : Color(0xFF043377),
              ),
            ),
            const SizedBox(height: 8),

            // Employment Type Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black54 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.black87 : Colors.grey.shade300,
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Select your employment type:",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'OakSans',
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildEmploymentOption("Self-Employed"),
                  _buildEmploymentOption("Freelancer"),
                  _buildEmploymentOption("Limited Company Director"),
                  _buildEmploymentOption("PAYE Employee"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Personalized Tax Tips (No Box)
            Text(
              "Personalized Tax Tips",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'OakSans',
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Color(0xFF49B3CD) : Color(0xFF043377),
              ),
            ),
            const SizedBox(height: 8),


            // Tax Tips Boxes
            _buildTaxTip(
              "Business Mileage",
              "As a self-employed, you can claim 45p per mile for the first 10,000 business miles, then 25p per mile thereafter.",
              isDarkMode,
            ),
            _buildTaxTip(
              "VAT Registration",
              "Consider voluntary VAT registration even if below the £85,000 threshold to reclaim VAT on expenses.",
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build Employment Option Buttons
  Widget _buildEmploymentOption(String title) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmploymentType = title;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode
              ? (selectedEmploymentType == title ? Color(0xFF49B3CD) : Colors.black87)
              : (selectedEmploymentType == title ? Color(0xFF004B9C) : Colors.white),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'OakSans',
            fontWeight: FontWeight.normal,
            color: selectedEmploymentType == title
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }

  // Widget to build Tax Tip Cards
  Widget _buildTaxTip(String title, String description, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF004B9C) : Colors.blue[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (isDarkMode)
            BoxShadow(
              color: Colors.black87,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'OakSans',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
