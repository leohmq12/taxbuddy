import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash_screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screens/splash_screen.dart';
import 'screens/splash_screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tax Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.jostTextTheme(),
      ),

      // 🔹 Check if User is Already Logged In
      home: const Splashscreen(),
    );
  }
}
/// **🔹 AuthChecker Widget**
/// Checks if user is new (show onboarding), else checks authentication
class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isNewUser = true; // Default to new user

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  /// **🔍 Check if First-Time User**
  Future<void> _checkFirstTimeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenOnboarding = prefs.getBool("hasSeenOnboarding");

    setState(() {
      _isNewUser = hasSeenOnboarding == null || !hasSeenOnboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // 🔄 Loading state
        }

        if (_isNewUser) {
          return const Splashscreen(); // 🚀 Show Onboarding First
        }

        if (snapshot.hasData) {
          return const HomeScreen(); // ✅ User logged in, go to Home
        }

        return const LoginScreen(); // 🔑 Not logged in, show Login
      },
    );
  }
}