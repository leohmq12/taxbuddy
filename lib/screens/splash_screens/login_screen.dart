import 'package:flutter/material.dart';
import '../splash_screens/signup_screen.dart';
import '../splash_screens/home.dart';
import 'package:taxbuddy/backend/auth/auth.dart'; // Import AuthService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // ✅ Firebase AuthService instance
  String _errorMessage = '';
  String _successMessage = ''; // ✅ Added for reset password feedback

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); // Refresh UI on focus change
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter both email and password.";
        _successMessage = "";
      });
      return;
    }

    try {
      var user = await _authService.authenticateUser(email, password, isLogin: true);
      if (user != null) {
        if (!user.emailVerified) {
          setState(() {
            _errorMessage = "Email not verified. Please check your inbox and verify.";
            _successMessage = "";
          });
          return;
        }
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } else {
        setState(() {
          _errorMessage = "Invalid email or password. Please try again.";
          _successMessage = "";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
        _successMessage = "";
      });
    }
  }

  void _handleForgotPasswordDialog() {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enter your email address to reset your password."),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isEmpty) return;
                try {
                  await _authService.resetPassword(email);
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Success"),
                        content: const Text("A password reset link has been sent to your email."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  Navigator.pop(context);
                  setState(() {
                    _errorMessage = "Error: $e";
                  });
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset('assets/images/ls.png', width: 120)),
              const SizedBox(height: 20),
              const Center(
                child: Text('Log In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              _buildTextField('Email Address', 'Enter your Email', false, _emailFocus, _emailController),
              const SizedBox(height: 15),
              _buildTextField('Password', 'Enter your Password', true, _passwordFocus, _passwordController),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004B9C),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Log In', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
                  child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF004B9C))),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: _handleForgotPasswordDialog,
                  child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF004B9C))),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, bool isPassword, FocusNode focusNode, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        TextField(
          focusNode: focusNode,
          controller: controller,
          obscureText: isPassword ? !_isPasswordVisible : false,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }
}
