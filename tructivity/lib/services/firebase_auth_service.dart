import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tructivity/local%20auth/local-auth-service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
      );
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    // Clear local auth data
    await authService.clearStorage();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.updatePhotoURL(photoURL);
    }
  }
}

// Global instance of FirebaseAuthService
final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

// Show auth error dialog
void showAuthErrorDialog(BuildContext context, FirebaseAuthException e) {
  String errorMessage = 'An error occurred';
  
  switch (e.code) {
    case 'user-not-found':
      errorMessage = 'No user found with this email.';
      break;
    case 'wrong-password':
      errorMessage = 'Wrong password provided.';
      break;
    case 'email-already-in-use':
      errorMessage = 'The email address is already in use.';
      break;
    case 'weak-password':
      errorMessage = 'The password is too weak.';
      break;
    case 'invalid-email':
      errorMessage = 'The email address is invalid.';
      break;
    default:
      errorMessage = e.message ?? 'An error occurred';
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Authentication Error'),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}