import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash_screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screens/splash_screen.dart';
import 'screens/splash_screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taxbuddy/backend/settings/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:taxbuddy/backend/settings/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingsBackend _settingsBackend = SettingsBackend();
  bool isDarkMode = (await _settingsBackend.getSetting('darkMode')) ?? false; // ✅ Load Dark Mode setting

  try {
    await dotenv.load(fileName: ".env");
    print("✅ .env file loaded successfully");
  } catch (e) {
    print("❌ Error loading .env file: $e");
  }

  await Firebase.initializeApp();
  print("✅ Firebase Initialized");

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  print("🟢 User: ${user?.email}, IsFirstTime: $isFirstTime");

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()..setDarkMode(isDarkMode), // ✅ Apply saved Dark Mode state
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MyApp(
          user: user,
          isFirstTime: isFirstTime,
        ),
      ),
    ),
  );
}

/// **🌟 MyApp Class**
class MyApp extends StatelessWidget {
  final User? user;
  final bool isFirstTime;

  const MyApp({super.key, required this.user, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // ✅ Listen to ThemeProvider

    return MaterialApp(
      title: 'Tax Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.jostTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.jostTextTheme(),
        scaffoldBackgroundColor: Colors.black87,
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, // ✅ Apply Dark/Light Mode
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
