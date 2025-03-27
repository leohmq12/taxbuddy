import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class SettingsBackend {
  final FlutterTts _flutterTts = FlutterTts();

  /// ✅ Constructor ensures UK English TTS is set when the class is initialized.
  SettingsBackend() {
    _initializeTTS();
  }

  /// 🎙 Initialize FlutterTTS with UK English (en-GB)
  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-GB"); // 🇬🇧 British English
  }

  /// 🔹 Load saved settings from SharedPreferences
  Future<Map<String, bool>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'voiceGuidance': prefs.getBool('voiceGuidance') ?? true,
      'darkMode': prefs.getBool('darkMode') ?? false,
      'simplifiedLanguage': prefs.getBool('simplifiedLanguage') ?? true,
    };
  }

  /// 🔹 Save a setting persistently
  Future<void> saveSetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// 🔹 Retrieve a specific setting
  Future<bool> getSetting(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(key == 'darkMode') {
      return prefs.getBool(key) ?? false;
    }
    return prefs.getBool(key) ?? true;
  }


  /// 🔹 Enable or disable Voice Guidance (TTS)
  Future<void> toggleVoiceGuidance(bool isEnabled) async {
    await saveSetting('voiceGuidance', isEnabled);
    if (isEnabled) {
      await _flutterTts.speak("Voice Guidance activated.");
    } else {
      await _flutterTts.speak("Voice Guidance deactivated.");
    }
  }

  /// 🔹 Enable or disable Simplified Language mode
  Future<void> toggleSimplifiedLanguage(bool isEnabled) async {
    await saveSetting('simplifiedLanguage', isEnabled);
    // ✅ Check if Voice Guidance is enabled before speaking
    bool isVoiceGuidanceEnabled = await getSetting('voiceGuidance');
    if (isVoiceGuidanceEnabled) {
      if (isEnabled) {
        await _flutterTts.speak("Simplified Language mode activated.");
      } else {
        await _flutterTts.speak("Simplified Language mode deactivated.");
      }
    }
  }
  /// 🔹 Logout function (Firebase Authentication)
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
