import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// **🔹 Authenticate User (Login / Sign Up)**
  Future<User?> authenticateUser(String email, String password, {required bool isLogin}) async {
    try {
      UserCredential userCredential;

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }

      return userCredential.user;
    } catch (e) {
      print("Authentication Error: $e");
      return null; // Ensure that if an error occurs, we return null
    }
  }
}
