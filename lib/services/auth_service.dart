import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase auth instance

  FirebaseAuth get auth => _auth;

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      developer.log('Attempting to create user: $email', name: 'AuthService');

      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      // Convert Firebase error codes to readable messages
      switch (e.code) {
        case 'weak-password':
          throw 'The password is too weak.';
        case 'email-already-in-use':
          throw 'An account already exists with this email.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        default:
          throw e.message ?? 'An unknown error occurred during registration';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      developer.log('Attempting to log in: $email', name: 'AuthService');

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      // Convert Firebase error codes to readable messages
      switch (e.code) {
        case 'user-not-found':
          throw 'No user found with this email.';
        case 'wrong-password':
          throw 'Incorrect password.';
        case 'invalid-email':
          throw 'The email address is not valid.';
        default:
          throw e.message ?? 'An unknown error occurred during login';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
