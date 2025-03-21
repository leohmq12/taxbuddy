import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsBackend {
  Future<Map<String, bool>> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'voiceGuidance': prefs.getBool('voiceGuidance') ?? true,
      'darkMode': prefs.getBool('darkMode') ?? false,
      'simplifiedLanguage': prefs.getBool('simplifiedLanguage') ?? true,
    };
  }

  Future<void> saveSetting(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
