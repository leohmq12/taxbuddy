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

  /// **🔹 Handle Login Action**
  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter both email and password.";
      });
      return;
    }

    try {
      debugPrint("🟡 Attempting login for: $email");

      var user = await _authService.authenticateUser(email, password, isLogin: true);

      if (user != null) {
        debugPrint("✅ Login successful for: $email");

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        setState(() {
          _errorMessage = "Invalid email or password. Please try again.";
        });
        debugPrint("❌ Firebase returned NULL user object.");
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
      });
      debugPrint("❌ Firebase Authentication Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Center(child: Image.asset('assets/images/ls.png', width: 120)),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField('Email Address', 'Enter your Email Address', false, _emailFocus, _emailController),
                    const SizedBox(height: 15),
                    _buildTextField('Password', 'Enter your Password', true, _passwordFocus, _passwordController),
                    const SizedBox(height: 10),

                    // **🔴 Error Message (if any)**
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                        ),
                      ),

                    // **🔹 Login Button**
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004B9C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _handleLogin, // ✅ Calls _handleLogin function
                      child: const Text('Log In', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),

                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF004B9C))),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to Forgot Password
                        },
                        child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF004B9C))),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// **Reusable Text Field**
  Widget _buildTextField(String label, String hint, bool isPassword, FocusNode focusNode, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          focusNode: focusNode,
          controller: controller,
          obscureText: isPassword ? !_isPasswordVisible : false,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}
