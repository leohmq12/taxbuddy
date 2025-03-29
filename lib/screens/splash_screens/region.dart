import 'package:flutter/material.dart';

class SelectRegionScreen extends StatefulWidget {
  final VoidCallback onBackToHome; // Changed from onBackPressed to clarify purpose

  const SelectRegionScreen({super.key, required this.onBackToHome});

  @override
  _SelectRegionScreenState createState() => _SelectRegionScreenState();
}

class _SelectRegionScreenState extends State<SelectRegionScreen> {
  String? _selectedRegion;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onBackToHome(); // Redirect to home screen
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Select your region',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'OakSans',
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: widget.onBackToHome, // Redirect to home screen
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: ListView(
          children: [
            _buildRegionTile(context, 'England'),
            _buildRegionTile(context, 'Wales'),
            _buildRegionTile(context, 'Scotland'),
            _buildRegionTile(context, 'Northern Ireland'),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionTile(BuildContext context, String region) {
    bool isSelected = _selectedRegion == region;
    return ListTile(
      title: Text(
        region,
        style: TextStyle(
          fontFamily: 'OakSans',
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: isSelected
              ? (Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF49B3CD)
              : Color(0xFF043377))
              : (Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.onSurface
              : Color(0xFF4F5C6F)),
        ),
      ),
      onTap: () {
        setState(() {
          _selectedRegion = region;
        });
        // Optional: Add this if you want to go back after selection
        // widget.onBackToHome();
      },
    );
  }
}