import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';
import 'firestore_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  static Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Create or update user in Firestore
        final appUser = AppUser(
          id: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoURL: user.photoURL,
          isGuest: false,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          preferredLanguage: 'ar',
          favoriteMovies: [],
          favoriteTvShows: [],
        );

        await FirestoreService.createOrUpdateUser(appUser);
        await _saveUserPreferences(appUser);
        return appUser;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
    return null;
  }

  // Sign in as guest
  static Future<AppUser> signInAsGuest() async {
    try {
      final appUser = AppUser.createGuest();
      await _saveUserPreferences(appUser);
      return appUser;
    } catch (e) {
      print('Error signing in as guest: $e');
      rethrow;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      await _clearUserPreferences();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if user is signed in
  static Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppConstants.userIdKey);
    return userId != null;
  }

  // Get current app user
  static Future<AppUser?> getCurrentAppUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppConstants.userIdKey);
    final isGuest = prefs.getBool(AppConstants.isGuestKey) ?? false;

    if (userId == null) return null;

    if (isGuest) {
      // Return guest user
      return AppUser(
        id: userId,
        isGuest: true,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        preferredLanguage: prefs.getString(AppConstants.languageKey) ?? 'ar',
        favoriteMovies: [],
        favoriteTvShows: [],
      );
    } else {
      // Get user from Firestore
      return await FirestoreService.getUser(userId);
    }
  }

  // Save user preferences
  static Future<void> _saveUserPreferences(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userIdKey, user.id);
    await prefs.setBool(AppConstants.isGuestKey, user.isGuest);
    await prefs.setString(AppConstants.languageKey, user.preferredLanguage);
  }

  // Clear user preferences
  static Future<void> _clearUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userIdKey);
    await prefs.remove(AppConstants.isGuestKey);
  }

  // Update user language preference
  static Future<void> updateLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, languageCode);

    final user = await getCurrentAppUser();
    if (user != null && !user.isGuest) {
      final updatedUser = user.copyWith(preferredLanguage: languageCode);
      await FirestoreService.createOrUpdateUser(updatedUser);
    }
  }

  // Get user language preference
  static Future<String> getLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.languageKey) ?? 'ar';
  }
}