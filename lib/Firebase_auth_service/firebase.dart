import 'package:cloud_firestore/cloud_firestore.dart';
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
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return handleAuthError(e.code);
    } catch (e) {
      return "Somthing went Wrong ";
    }
  }

  Future<String?> signin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential!.user;
      await user?.reload();
      user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        return "Please verify email first";
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return handleAuthError(e.code);
    } catch (e) {
      return "Somthing went Wrong ";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> forgotpassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return handleAuthError(e.code);
    } catch (e) {
      return "Something went wrong";
    }
  }

  Future<void> saveUserData({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,

  }) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "uid": uid,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "city": city,
      "createdAt": DateTime.now(),
    });
  }

  Future<String?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (doc.exists) {
      return doc["name"];
    }
    return null;
  }

  Future<bool> addToCart({
    required String productId,
    required String title,
    required int quantity,
    required double price,
    required String image,
    required double TotlePrice,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("cart")
          .doc(productId)
          .set({
            "productId": productId,
            "title": title,
            "quantity": quantity,
            "price": price,
            "TotalPrice":TotlePrice,
            "image": image,
            "createdAt": FieldValue.serverTimestamp(),
          });
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getCartItems() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return Stream.empty();
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("cart")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

}
