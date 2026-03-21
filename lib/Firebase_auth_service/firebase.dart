import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  String handleAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return "Enter a valid email address";

      case 'user-not-found':
        return "Account not found. Please sign up first";

      case 'wrong-password':
        return "Incorrect password. Try again";

      case 'invalid-credential':
        return "Invalid email or password";

      case 'email-already-in-use':
        return "Email already registered. Please login";

      case 'weak-password':
        return "Password must be at least 6 characters";

      case 'user-disabled':
        return "This account has been disabled";

      case 'too-many-requests':
        return "Too many attn empts. Try again later";

      case 'network-request-failed':
        return "Check your internet connection";

      default:
        return "Login failed. Please try again";
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return handleAuthError(e.code);
    } catch (e) {
      return "Somthing went Wrong ";
    }
  }

  Future<String?> signin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return handleAuthError(e.code);
    } catch (e) {
      return "Somthing went Wrong ";
    }
  }
}
