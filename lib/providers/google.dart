import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  /// ✅ Function to log in with Google and return UserCredential
  Future<UserCredential?> googleLogin() async {
    try {
      // ✅ Ensure the user selects an account by signing out first
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled login

      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      notifyListeners();
      return userCredential; // ✅ Return UserCredential after successful login
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return null;
    }
  }
}
