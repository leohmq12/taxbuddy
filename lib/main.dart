import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash_screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screens/splash_screen.dart';
import 'screens/splash_screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await dotenv.load(fileName: ".env");
    print ("✅ .env file loaded successfully");
  } catch (e) {
    print ("❌ Error loading .env file: $e");
  }
  await Firebase.initializeApp();

  print("✅ Firebase Initialized");

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  print("🟢 User: \${user?.email}, IsFirstTime: \$isFirstTime");

  runApp(MyApp(user: user, isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final User? user;
  final bool isFirstTime;

  const MyApp({super.key, required this.user, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tax Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.jostTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthChecker(isFirstTime: isFirstTime, user: user),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

/// **🔹 AuthChecker Widget**
/// Checks if user is new (show onboarding), else checks authentication
class AuthChecker extends StatefulWidget {
  final bool isFirstTime;
  final User? user;

  const AuthChecker({super.key, required this.isFirstTime, required this.user});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  late bool _isNewUser;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _isNewUser = widget.isFirstTime;
    _currentUser = widget.user;
    _checkUserAuthStatus();
  }

  /// **🔍 Check Firebase Authentication State**
  void _checkUserAuthStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ If first-time user → Show onboarding
    if (_isNewUser) return const Splashscreen();

    // ✅ If logged in → Go to HomeScreen
    if (_currentUser != null) return const HomeScreen();

    // 🔑 If not logged in → Show LoginScreen
    return const LoginScreen();
  }
}
