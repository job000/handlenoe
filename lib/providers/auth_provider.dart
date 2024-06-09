import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _authService.authStateChanges().listen((User? user) async {
      _user = user;
      if (_user != null) {
        await _saveUserToFirestore(_user!);
      }
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    _user = await _authService.signInWithGoogle();
    if (_user != null) {
      await _saveUserToFirestore(_user!);
    }
    notifyListeners();
  }

  Future<void> registerWithGoogle() async {
    _user = await _authService.registerWithGoogle();
    if (_user != null) {
      await _saveUserToFirestore(_user!);
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _user = await _authService.signIn(email, password);
    if (_user != null) {
      await _saveUserToFirestore(_user!);
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _user = await _authService.register(email, password);
    if (_user != null) {
      await _saveUserToFirestore(_user!);
    }
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

  Future<void> _saveUserToFirestore(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'uid': user.uid,
      // Add other fields if needed
    }, SetOptions(merge: true));
  }
}
