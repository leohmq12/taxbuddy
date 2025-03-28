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
  bool _isVerificationSent = false; // Track if verification email is sent
  String? _message; // Store message for errors/success

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
      setState(() {
        _message = "Please enter email and password";
      });
      return;
    }

    User? user = await _authService.authenticateUser(email, password, isLogin: false);

    if (user != null) {
      // Send email verification
      await user.sendEmailVerification();

      setState(() {
        _signUpResult = true;
        _isVerificationSent = true;
        _message = "Verification email sent! Please check your inbox.";
      });
    } else {
      setState(() {
        _signUpResult = false;
        _message = "Sign Up Failed! Email may already exist.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'OakSans',
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? const Color(0xFF49B3CD) // ✅ Dark Mode: Keep existing color
                        : const Color(0xFF043377), // ✅ Light Mode: Corrected color
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _buildLabel("Full Name", isDarkMode),
              _buildTextField(_nameController, _nameFocus, "Enter your Full Name", isDarkMode),
              const SizedBox(height: 20),

              _buildLabel("Email Address", isDarkMode),
              _buildTextField(_emailController, _emailFocus, "Enter your Email Address", isDarkMode, isEmail: true),
              const SizedBox(height: 20),

              _buildLabel("Password", isDarkMode),
              _buildPasswordField(isDarkMode),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              if (_message != null) ...[
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color: _signUpResult == true ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const SizedBox(height: 10),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontFamily: 'OakSans',
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Color(0xFF49B3CD)
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (_signUpResult == true)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "Go to Login",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDarkMode) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDarkMode
            ? Theme.of(context).textTheme.bodyLarge!.color // ✅ Dark mode follows theme
            : const Color(0xFF043377), // ✅ Light mode uses correct color
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, FocusNode focusNode, String hint, bool isDarkMode, {bool isEmail = false}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isDarkMode) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: !_isPasswordVisible,
      style: TextStyle(
        color: isDarkMode ? Colors.white.withOpacity(0.9) : Colors.black
            .withOpacity(0.9),
      ),
      // Match opacity with email field
      decoration: InputDecoration(
        hintText: "Enter your Password",
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors
              .black54, // Match hint color with email field
        ),
        filled: true,
        fillColor: Theme
            .of(context)
            .cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          onPressed: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }
}
