import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isVoiceGuidanceOn = true;
  bool isDarkModeOn = false;
  bool isSimplifiedLanguageOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light gray background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Section
              Container(
                width: 201, // Adjust width based on your image
                height: 124, // Adjust height as needed
                child: Image.asset(
                  'assets/images/ls.png', // Replace with your actual asset path
                  fit: BoxFit.contain, // Ensures the image is not cropped
                ),
              ),

              SizedBox(height: 5),
              Text(
                "Version 1.0.0",
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              SizedBox(height: 20),

              // App Settings Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "App Settings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),

              // Settings Card
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      title: "Voice Guidance",
                      subtitle: "Enable spoken explanations",
                      value: isVoiceGuidanceOn,
                      onChanged: (newValue) {
                        setState(() {
                          isVoiceGuidanceOn = newValue;
                        });
                      },
                    ),
                    Divider(),
                    _buildSettingTile(
                      title: "Dark Mode",
                      subtitle: "Use dark theme",
                      value: isDarkModeOn,
                      onChanged: (newValue) {
                        setState(() {
                          isDarkModeOn = newValue;
                        });
                      },
                    ),
                    Divider(),
                    _buildSettingTile(
                      title: "Simplified Language",
                      subtitle: "Avoid tax jargon",
                      value: isSimplifiedLanguageOn,
                      onChanged: (newValue) {
                        setState(() {
                          isSimplifiedLanguageOn = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Log Out Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Widget for Setting Options (Only Switch is Tappable)
  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged, // Only the switch is tappable
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
