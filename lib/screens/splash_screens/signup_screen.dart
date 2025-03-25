import 'package:taxbuddy/backend/auth/auth.dart'; // Import AuthService
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../splash_screens/login_screen.dart'; // Import Login Screen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;
  final AuthService _authService = AuthService(); // AuthService instance

  bool? _signUpResult; // Null initially, true if successful, false if failed

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_updateUI);
    _emailFocus.addListener(_updateUI);
    _passwordFocus.addListener(_updateUI);
  }

  @override
  void dispose() {
    _nameFocus.removeListener(_updateUI);
    _emailFocus.removeListener(_updateUI);
    _passwordFocus.removeListener(_updateUI);

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    User? user = await _authService.authenticateUser(email, password, isLogin: false);

    setState(() {
      _signUpResult = user != null; // true if signup successful, false otherwise
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(child: Image.asset("assets/images/ls.png", height: 80)),

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              const Text("Full Name"),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  hintText: "Enter your Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Email Address"),
              TextField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter your Email Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              const Text("Password"),
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Enter your Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004B9C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Sign In",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // SIGNUP RESULT MESSAGE AND BUTTON
              if (_signUpResult != null) ...[
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _signUpResult!
                        ? "Sign Up Successful! Please Login."
                        : "Sign Up Failed! Email may already exist.",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_signUpResult!) {
                        // If successful, navigate to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      } else {
                        // If failed, reset the state to allow retry
                        setState(() {
                          _signUpResult = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(_signUpResult! ? "Go Back to Login" : "Try Again"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
