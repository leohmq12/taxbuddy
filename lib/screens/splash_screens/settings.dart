import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxbuddy/backend/settings/settings_service.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Required for Text-to-Speech
import 'package:taxbuddy/backend/settings/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsBackend _settingsBackend = SettingsBackend();
  final FlutterTts flutterTts = FlutterTts(); // Initialize TTS

  bool isVoiceGuidanceOn = true;
  bool isDarkModeOn = false;
  bool isSimplifiedLanguageOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    var settings = await _settingsBackend.loadSettings();
    setState(() {
      isVoiceGuidanceOn = settings['voiceGuidance']!;
      isDarkModeOn = settings['darkMode']!;
      isSimplifiedLanguageOn = settings['simplifiedLanguage']!;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    if (key == 'voiceGuidance') {
      await _settingsBackend.toggleVoiceGuidance(value);
      if (value) {
        await flutterTts.speak("Voice Guidance enabled");
      } else {
        await flutterTts.speak("Voice Guidance disabled");
      }
    } else if (key == 'simplifiedLanguage') {
      await _settingsBackend.toggleSimplifiedLanguage(value);
    } else {
      await _settingsBackend.saveSetting(key, value);
    }
  }

  Future<void> _logout() async {
    await _settingsBackend.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No", style: TextStyle(color: Color(0xFF004B9C))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: const Text("Yes", style: TextStyle(color: Color(0xFF004B9C))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/image1.png'),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(
              "Settings",
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        )

      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 201,
                height: 124,
                child: Image.asset('assets/images/ls.png', fit: BoxFit.contain),
              ),
              const SizedBox(height: 5),
              Text("Version 1.0.0", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("App Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
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
                        _updateSetting('voiceGuidance', newValue);
                      },
                    ),
                    const Divider(),
                    _buildSettingTile(
                      title: "Dark Mode",
                      subtitle: "Use dark theme",
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (newValue) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleDarkMode(newValue);
                        _updateSetting('darkMode', newValue); // ✅ Optional, but make sure this updates SharedPreferences if needed.
                      },
                    ),

                    const Divider(),
                    _buildSettingTile(
                      title: "Simplified Language",
                      subtitle: "Avoid tax jargon",
                      value: isSimplifiedLanguageOn,
                      onChanged: (newValue) {
                        setState(() {
                          isSimplifiedLanguageOn = newValue;
                        });
                        _updateSetting('simplifiedLanguage', newValue);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showLogoutConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004B9C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
        ],
      ),
    );
  }
}
