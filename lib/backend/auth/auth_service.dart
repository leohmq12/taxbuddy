import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash_screens/home.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true; // Toggle between login & signup
  String errorMessage = ''; // Display error messages

  /// **🔹 Handle Login / Sign Up**
  Future<void> _authenticateUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Email and Password cannot be empty!";
      });
      return;
    }

    try {
      if (isLogin) {
        // **🔹 Log In User**
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        // **🔹 Sign Up User**
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }

      // **✅ Navigate to HomeScreen after successful Login/SignUp**
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Authentication failed!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLogin ? "Log In" : "Sign Up",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // **Email Input Field**
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),

            // **Password Input Field**
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // **🔴 Error Message**
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            // **Login / SignUp Button**
            ElevatedButton(
              onPressed: _authenticateUser,
              child: Text(isLogin ? "Log In" : "Sign Up"),
            ),

            const SizedBox(height: 10),

            // **Switch between Login & SignUp**
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                  errorMessage = ''; // Reset error message when switching
                });
              },
              child: Text(isLogin ? "Create an Account" : "Already have an account? Log In"),
            ),
          ],
        ),
      ),
    );
  }
}
