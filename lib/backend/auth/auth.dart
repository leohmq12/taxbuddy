import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Authenticate User (Login or Signup)
  Future<User?> authenticateUser(String email, String password, {bool isLogin = true}) async {
    try {
      UserCredential userCredential;

      if (isLogin) {
        // 🔹 LOGIN user
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        // 🔹 SIGNUP user
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }

      return userCredential.user;
    } catch (e) {
      print("Firebase Auth Error: $e");
      return null; // Return null if authentication fails
    }
  }
}
