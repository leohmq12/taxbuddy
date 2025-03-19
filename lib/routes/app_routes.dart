import 'package:flutter/material.dart';
import '../screens/splash_screens/splash_screen1.dart';
import '../screens/splash_screens/splash_screen2.dart';
import '../screens/splash_screens/splash_screen3.dart';
import '../screens/splash_screens/splash_screen4.dart';
import '../screens/splash_screens/login_screen.dart';
import '../screens/splash_screens/signup_screen.dart';
import '../screens/splash_screens/home.dart';
import '../screens/splash_screens/tax_calculator.dart';
import '../screens/splash_screens/settings.dart';
import '../screens/splash_screens/profile.dart';
import '../screens/splash_screens/splash_screen11.dart';
import '../screens/auth/login.dart';
import '../screens/auth/signup.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignupScreen(),
    '/splash1': (context) => const SplashScreen1(),
    '/splash2': (context) => const SplashScreen2(),
    // Add more screens...
  };
}
