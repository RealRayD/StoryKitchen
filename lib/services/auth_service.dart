import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      // Log the attempt for debugging
      developer.log('Attempting to create user: $email',
          name: 'AuthService.signUpWithEmail');

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Log successful creation
      developer.log('User created successfully: ${userCredential.user?.uid}',
          name: 'AuthService.signUpWithEmail');

      return true;
    } on FirebaseAuthException catch (e) {
      // Detailed logging of Firebase-specific errors
      developer.log('Firebase Auth Error: ${e.code}',
          name: 'AuthService.signUpWithEmail', error: e.message);

      // Explicitly convert to a clear error message
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
      // Catch-all for any other unexpected errors
      developer.log('Unexpected error during signup: $e',
          name: 'AuthService.signUpWithEmail');

      throw 'An unexpected error occurred: $e';
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      // Similar logging for login
      developer.log('Attempting to log in: $email',
          name: 'AuthService.loginWithEmail');

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      developer.log('User logged in successfully: ${userCredential.user?.uid}',
          name: 'AuthService.loginWithEmail');

      return true;
    } on FirebaseAuthException catch (e) {
      // Detailed logging of Firebase-specific errors
      developer.log('Firebase Auth Error: ${e.code}',
          name: 'AuthService.loginWithEmail', error: e.message);

      // Explicitly convert to a clear error message
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
      // Catch-all for any other unexpected errors
      developer.log('Unexpected error during login: $e',
          name: 'AuthService.loginWithEmail');

      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      developer.log('Error during sign out: $e', name: 'AuthService.signOut');
      rethrow;
    }
  }
}
