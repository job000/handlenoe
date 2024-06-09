import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _authService.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    _user = await _authService.signInWithGoogle();
    notifyListeners();
  }

  Future<void> registerWithGoogle() async {
    _user = await _authService.registerWithGoogle();
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _user = await _authService.signIn(email, password);
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _user = await _authService.register(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }
}
