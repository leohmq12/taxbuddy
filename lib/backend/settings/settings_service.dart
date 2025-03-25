import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SettingsBackend {
  final FlutterTts _flutterTts = FlutterTts();

  /// Load saved settings
  Future<Map<String, bool>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'voiceGuidance': prefs.getBool('voiceGuidance') ?? true,
      'darkMode': prefs.getBool('darkMode') ?? false,
      'simplifiedLanguage': prefs.getBool('simplifiedLanguage') ?? true,
    };
  }

  /// Save a setting persistently
  Future<void> saveSetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
  Future<bool> getSetting(String key) async {
    // Retrieve setting from storage, assuming you're using SharedPreferences or another storage method
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
  /// Logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Enable or disable Voice Guidance (TTS)
  Future<void> toggleVoiceGuidance(bool isEnabled) async {
    await saveSetting('voiceGuidance', isEnabled);
    if (isEnabled) {
      await _flutterTts.speak("Voice Guidance is now enabled.");
    } else {
      await _flutterTts.speak("Voice Guidance is now disabled.");
    }
  }

  /// Enable or disable Simplified Language mode
  Future<void> toggleSimplifiedLanguage(bool isEnabled) async {
    await saveSetting('simplifiedLanguage', isEnabled);
    // Retrieve Voice Guidance setting before speaking
    bool isVoiceGuidanceEnabled = await getSetting('voiceGuidance');
    if (isVoiceGuidanceEnabled) {
      if (isEnabled) {
        await _flutterTts.speak("Simplified Language mode activated.");
      } else {
        await _flutterTts.speak("Simplified Language mode deactivated.");
      }
    }
  }
}
