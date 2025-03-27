import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  /// **✅ Load Dark Mode from SharedPreferences**
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  /// **✅ Set Dark Mode (Used at Startup)**
  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  /// **🌙 Toggle Dark Mode, Save & Speak**
  void toggleDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    notifyListeners();

    // ✅ Check if Voice Guidance is enabled before speaking
    SharedPreferences settings = await SharedPreferences.getInstance();
    bool isVoiceGuidanceEnabled = settings.getBool('voiceGuidance') ?? true;

    if (isVoiceGuidanceEnabled) {
      FlutterTts flutterTts = FlutterTts();
      await flutterTts.setLanguage("en-GB");
      await flutterTts.speak(
          isDark ? "Dark mode activated." : "Dark mode deactivated.");
    }
  }
}
