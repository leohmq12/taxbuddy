import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxbuddy/backend/settings/settings_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:taxbuddy/backend/settings/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsBackend _settingsBackend = SettingsBackend();
  final FlutterTts flutterTts = FlutterTts();

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
              child: Text(
                "No",
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
              Text(
                "Version 1.0.0",
                style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "App Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'OakSans',
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Color(0xFF49B3CD) : Color(0xFF043377), // ✅ Fix
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      title: "Voice Guidance",
                      subtitle: "Enable spoken explanations",
                      value: isVoiceGuidanceOn,
                      isDarkMode: isDarkMode,
                      onChanged: (newValue) {
                        setState(() {
                          isVoiceGuidanceOn = newValue;
                        });
                        _updateSetting('voiceGuidance', newValue);
                      },
                    ),
                    _buildSettingTile(
                      title: "Dark Mode",
                      subtitle: "Use dark theme",
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      isDarkMode: isDarkMode,
                      onChanged: (newValue) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleDarkMode(newValue);
                        _updateSetting('darkMode', newValue);
                      },
                    ),
                    _buildSettingTile(
                      title: "Simplified Language",
                      subtitle: "Avoid tax jargon",
                      value: isSimplifiedLanguageOn,
                      isDarkMode: isDarkMode,
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
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
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF004B9C), // ✅ Fix
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
