import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
// Get Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Get current user
  User? get currentUser => _auth.currentUser;

// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

// Sign in with email and password
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

// Register with email and password
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

// Send verification email

      await result.user?.sendEmailVerification();

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

// Send password reset email
  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':

        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}