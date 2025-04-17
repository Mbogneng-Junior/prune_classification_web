// lib/services/database_service.dart

import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/plum_result.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  
  factory DatabaseService() => _instance;
  
  DatabaseService._internal();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "plum_analyzer.db");
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Créer la table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL,
        last_name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        password TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
    
    // Créer la table des analyses
    await db.execute('''
      CREATE TABLE analyses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        image_path TEXT NOT NULL,
        category INTEGER NOT NULL,
        confidence REAL NOT NULL,
        timestamp INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }
  
  // Hash du mot de passe pour le sécuriser
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Méthodes pour la gestion des utilisateurs
  
  static Future<int> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final db = await _instance.database;
    
    // Vérifier si l'email existe déjà
    final existingUser = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    
    if (existingUser.isNotEmpty) {
      throw Exception('Un utilisateur avec cet email existe déjà');
    }
    
    // Créer le nouvel utilisateur avec mot de passe hashé
    final userData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': _hashPassword(password),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    };
    
    return await db.insert('users', userData);
  }
  
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _instance.database;
    
    final users = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    
    if (users.isEmpty) {
      return null;
    }
    
    return users.first;
  }
  
  static Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await _instance.database;
    
    final users = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (users.isEmpty) {
      return null;
    }
    
    return users.first;
  }
  
  static Future<Map<String, dynamic>?> authenticateUser(String email, String password) async {
    final db = await _instance.database;
    
    final hashedPassword = _hashPassword(password);
    
    final users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );
    
    if (users.isEmpty) {
      return null;
    }
    
    return users.first;
  }
  
  static Future<bool> verifyUserPassword(int userId, String password) async {
    final db = await _instance.database;
    
    final hashedPassword = _hashPassword(password);
    
    final users = await db.query(
      'users',
      where: 'id = ? AND password = ?',
      whereArgs: [userId, hashedPassword],
    );
    
    return users.isNotEmpty;
  }
  
  static Future<void> updateUserProfile(
    int userId, {
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final db = await _instance.database;
    
    final userData = <String, dynamic>{};
    
    if (firstName != null) userData['first_name'] = firstName;
    if (lastName != null) userData['last_name'] = lastName;
    if (phone != null) userData['phone'] = phone;
    
    if (userData.isEmpty) return;
    
    await db.update(
      'users',
      userData,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  
  static Future<void> updateUserPassword(
    int userId,
    String newPassword,
  ) async {
    final db = await _instance.database;
    
    final hashedPassword = _hashPassword(newPassword);
    
    await db.update(
      'users',
      {'password': hashedPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  
  static Future<void> deleteUser(int userId) async {
    final db = await _instance.database;
    
    // Supprimer d'abord les analyses associées à l'utilisateur
    await db.delete(
      'analyses',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    
    // Puis supprimer l'utilisateur
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  
  // Méthodes pour la gestion des analyses
  
  static Future<void> saveAnalysisResult(
    String imagePath,
    PlumResult result, {
    int? userId,
  }) async {
    final db = await _instance.database;
    
    final analysisData = {
      'user_id': userId,
      'image_path': imagePath,
      'category': result.category.index,
      'confidence': result.confidence,
      'timestamp': result.timestamp.millisecondsSinceEpoch,
    };
    
    await db.insert('analyses', analysisData);
  }
  
  static Future<List<Map<String, dynamic>>> getAnalysisHistory({
    int? userId,
    int limit = 20,
  }) async {
    final db = await _instance.database;
    
    String whereClause = '';
    List<dynamic> whereArgs = [];
    
    if (userId != null) {
      whereClause = 'user_id = ?';
      whereArgs = [userId];
    }
    
    return await db.query(
      'analyses',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }
  
  static Future<void> deleteAnalysis(int analysisId) async {
    final db = await _instance.database;
    
    await db.delete(
      'analyses',
      where: 'id = ?',
      whereArgs: [analysisId],
    );
  }
  
  static Future<void> clearAnalysisHistory({int? userId}) async {
    final db = await _instance.database;
    
    if (userId != null) {
      await db.delete(
        'analyses',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } else {
      await db.delete('analyses');
    }
  }
}