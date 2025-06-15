import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../JSON/users.dart';
import '../SQLite/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Nouvelle méthode de login avec SQLite
  Future<bool> login(String username, String password) async {
    final db = DatabaseHelper();
    final isValid = await db.authenticate(Users(usrName: username, password: password));
    if (isValid) {
      final user = await db.getUser(username);
      if (user != null) {
        _currentUser = UserModel(
          id: user.usrId?.toString() ?? '',
          email: user.email ?? '',
          name: user.fullName ?? user.usrName,
        );
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // Nouvelle méthode d'inscription avec SQLite
  Future<bool> register(String email, String password, String name) async {
    final db = DatabaseHelper();
    try {
      final newUser = Users(
        fullName: name,
        email: email,
        usrName: email, // On utilise l'email comme username pour la cohérence
        password: password,
      );
      await db.createUser(newUser);
      // Après inscription, connecter l'utilisateur
      _currentUser = UserModel(
        id: '',
        email: email,
        name: name,
      );
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
} 