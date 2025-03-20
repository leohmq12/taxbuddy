import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedEmploymentType = "Self-Employed";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Dark blue app bar
        title: Text(
          "Your Profile",
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.grey[100], // Light gray background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Removed bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tax Profile Section
            const Text(
              "Tax Profile",
              style: TextStyle(fontSize: 18,fontFamily: 'OakSans', fontWeight: FontWeight.bold, color: Color(0xFF043377)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: Column(
                children: [
                  const Text("Select your employment type:",
                      style: TextStyle(fontSize: 12, fontFamily: 'OakSans', color: Colors.grey)),
                  const SizedBox(height: 8),
                  _buildEmploymentOption("Self-Employed"),
                  _buildEmploymentOption("Freelancer"),
                  _buildEmploymentOption("Limited Company Director"),
                  _buildEmploymentOption("PAYE Employee"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Personalized Tax Tips Section
            const Text(
              "Personalized Tax Tips",
              style: TextStyle(fontSize: 18, fontFamily: 'OakSans', fontWeight: FontWeight.bold, color: Color(0xFF043377)),
            ),
            const SizedBox(height: 8),
            _buildTaxTip("Business Mileage",
                "As a self-employed, you can claim 45p per mile for the first 10,000 business miles, then 25p per mile thereafter."),
            _buildTaxTip("VAT Registration",
                "Consider voluntary VAT registration even if below the £85,000 threshold to reclaim VAT on expenses."),
          ],
        ),
      ),
    );
  }

  // Widget to build Employment Option Buttons
  Widget _buildEmploymentOption(String title) {
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
          border: Border.all(
            color: selectedEmploymentType == title ? Colors.blue : Colors.grey,
            width: selectedEmploymentType == title ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'OakSans',
            fontWeight: FontWeight.normal,
            color: selectedEmploymentType == title ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }

  // Widget to build Tax Tip Cards
  Widget _buildTaxTip(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 14, fontFamily: 'OakSans', fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(description,
              style: const TextStyle(fontSize: 12, fontFamily: 'OakSans', color: Colors.white)),
        ],
      ),
    );
  }
}
