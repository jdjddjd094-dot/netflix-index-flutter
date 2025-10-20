import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AppUser? _user;
  bool _isLoading = false;
  String _language = 'ar';

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String get language => _language;
  bool get isSignedIn => _user != null;
  bool get isGuest => _user?.isGuest ?? false;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await AuthService.getCurrentAppUser();
      _language = await AuthService.getLanguagePreference();
    } catch (e) {
      print('Error initializing auth: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await AuthService.signInWithGoogle();
      if (user != null) {
        _user = user;
        _language = user.preferredLanguage;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signInAsGuest() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await AuthService.signInAsGuest();
      _user = user;
      _language = user.preferredLanguage;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error signing in as guest: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.signOut();
      _user = null;
      _language = 'ar';
    } catch (e) {
      print('Error signing out: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLanguage(String languageCode) async {
    try {
      await AuthService.updateLanguagePreference(languageCode);
      _language = languageCode;
      
      if (_user != null && !_user!.isGuest) {
        _user = _user!.copyWith(preferredLanguage: languageCode);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error updating language: $e');
    }
  }

  void updateUser(AppUser user) {
    _user = user;
    notifyListeners();
  }
}