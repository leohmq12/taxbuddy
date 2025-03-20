import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  'screens/splash_screens/login_screen.dart';
import 'screens/splash_screens/home.dart';
import 'screens/splash_screens/splash_screen.dart';

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
      home: FirebaseAuth.instance.currentUser == null
          ? const Splashscreen()
          : const HomeScreen(),
    );
  }
}
