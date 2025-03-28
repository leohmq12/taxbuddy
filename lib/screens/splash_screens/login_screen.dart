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
  final AuthService _authService = AuthService(); // Firebase AuthService instance

  String? _errorMessage; // Error message display

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_updateUI);
    _passwordFocus.addListener(_updateUI);
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

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
      var user = await _authService.authenticateUser(
          email, password, isLogin: true);
      if (user != null) {
        if (!user.emailVerified) {
          setState(() {
            _errorMessage = "Email not verified. Please check your inbox.";
          });
          return;
        }
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } else {
        setState(() {
          _errorMessage = "Invalid email or password. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: $e";
      });
    }
  }

  void _handleForgotPasswordDialog() {
    TextEditingController emailController = TextEditingController();
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Password"),
          backgroundColor: Theme.of(context).dialogBackgroundColor, // Matches theme
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your email address to reset your password."),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor, // Matches theme
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, // Matches theme
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, // Matches theme
                      width: 2,
                    ),
                  ),
                ),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white), // ✅ Always White
              ),
            ),
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isEmpty) return;
                try {
                  await _authService.resetPassword(email);
                  Navigator.pop(context);
                  _showSuccessDialog(
                    "A password reset link has been sent to your email.",
                  );
                } catch (e) {
                  Navigator.pop(context);
                  setState(() {
                    _errorMessage = "Error: $e";
                  });
                }
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white), // ✅ Always White
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: const Text("OK")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(child: Image.asset("assets/images/ls.png", height: 80)),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'OakSans',
                    fontWeight: FontWeight.bold,
                    color: Theme
                        .of(context)
                        .brightness == Brightness.dark // Apply color only in dark mode
                        ? const Color(0xFF49B3CD) // ✅ Dark Mode: Keep existing color
                        : const Color(0xFF043377) // ✅ Light Mode: Corrected to your color, // Default color for light mode
                  ),
                ),
              ),
              const SizedBox(height: 30),

              _buildLabel("Email Address", isDarkMode),
              _buildTextField(
                  _emailController, _emailFocus, "Enter your Email Address",
                  isDarkMode, isEmail: true),
              const SizedBox(height: 20),

              _buildLabel("Password", isDarkMode),
              _buildPasswordField(isDarkMode),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Log In",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],

              const SizedBox(height: 10),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle( // Set the base text style
                        fontSize: 12, // Ensure it matches your original text size
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontFamily: 'OakSans',
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF49B3CD)
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: GestureDetector(
                  onTap: _handleForgotPasswordDialog,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF49B3CD)
                          : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
            ? Theme.of(context).textTheme.bodyLarge!.color // ✅ Dark mode keeps theme color
            : const Color(0xFF043377), // ✅ Light mode uses your required color
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, FocusNode focusNode,
      String hint, bool isDarkMode, {bool isEmail = false}) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: Theme
            .of(context)
            .cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
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
