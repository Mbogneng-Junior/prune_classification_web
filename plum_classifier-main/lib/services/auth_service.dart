// lib/services/auth_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';
  
  static User? _currentUser;
  
  // Obtenir l'utilisateur actuel
  static User? get currentUser => _currentUser;
  
  // Vérifier si un utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  
  // Obtenir l'ID de l'utilisateur connecté
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }
  
  // Obtenir l'email de l'utilisateur connecté
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }
  
  // Charger les informations de l'utilisateur en mémoire
  static Future<User?> loadUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }
    
    final userId = await getUserId();
    if (userId == null) {
      return null;
    }
    
    try {
      // Récupérer les informations de l'utilisateur depuis la base de données
      final userMap = await DatabaseService.getUserById(userId);
      if (userMap != null) {
        _currentUser = User.fromMap(userMap);
        return _currentUser;
      }
    } catch (e) {
      print('Erreur lors du chargement de l\'utilisateur: $e');
    }
    
    return null;
  }
  
  // Connecter un utilisateur
  static Future<bool> login(int userId, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_userIdKey, userId);
      await prefs.setString(_userEmailKey, email);
      await prefs.setBool(_isLoggedInKey, true);
      
      // Charger les informations de l'utilisateur
      await loadUser();
      
      return true;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return false;
    }
  }
  
  // Authentifier un utilisateur avec email et mot de passe
  static Future<User?> authenticate(String email, String password) async {
    try {
      // Vérifier les identifiants
      final userMap = await DatabaseService.authenticateUser(email, password);
      
      if (userMap != null) {
        // Enregistrer la session
        await login(userMap['id'], email);
        
        _currentUser = User.fromMap(userMap);
        return _currentUser;
      }
    } catch (e) {
      print('Erreur lors de l\'authentification: $e');
    }
    
    return null;
  }
  
  // Déconnecter l'utilisateur
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_userEmailKey);
      await prefs.setBool(_isLoggedInKey, false);
      
      _currentUser = null;
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }
  
  // Mettre à jour les informations de l'utilisateur actuel
  static Future<bool> updateCurrentUser({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    if (_currentUser == null) {
      return false;
    }
    
    try {
      await DatabaseService.updateUserProfile(
        _currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      
      // Mettre à jour les données en mémoire
      if (firstName != null) _currentUser!.firstName = firstName;
      if (lastName != null) _currentUser!.lastName = lastName;
      if (phone != null) _currentUser!.phone = phone;
      
      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
      return false;
    }
  }
  
  // Changer le mot de passe de l'utilisateur actuel
  static Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (_currentUser == null) {
      return false;
    }
    
    try {
      // Vérifier l'ancien mot de passe
      final isValid = await DatabaseService.verifyUserPassword(
        _currentUser!.id,
        currentPassword,
      );
      
      if (!isValid) {
        return false;
      }
      
      // Mettre à jour le mot de passe
      await DatabaseService.updateUserPassword(
        _currentUser!.id,
        newPassword,
      );
      
      return true;
    } catch (e) {
      print('Erreur lors du changement de mot de passe: $e');
      return false;
    }
  }
  
  // Supprimer le compte de l'utilisateur actuel
  static Future<bool> deleteAccount(String password) async {
    if (_currentUser == null) {
      return false;
    }
    
    try {
      // Vérifier le mot de passe
      final isValid = await DatabaseService.verifyUserPassword(
        _currentUser!.id,
        password,
      );
      
      if (!isValid) {
        return false;
      }
      
      // Supprimer l'utilisateur et ses données
      await DatabaseService.deleteUser(_currentUser!.id);
      
      // Déconnecter l'utilisateur
      await logout();
      
      return true;
    } catch (e) {
      print('Erreur lors de la suppression du compte: $e');
      return false;
    }
  }
}