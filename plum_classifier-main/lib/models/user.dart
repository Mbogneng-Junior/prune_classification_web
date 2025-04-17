// lib/models/user.dart

class User {
  final int id;
  String firstName;
  String lastName;
  final String email;
  String phone;
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.createdAt,
  });
  
  // Nom complet de l'utilisateur
  String get fullName => '$firstName $lastName';
  
  // Initiales pour l'affichage
  String get initials => firstName.isNotEmpty && lastName.isNotEmpty
      ? '${firstName[0]}${lastName[0]}'
      : firstName.isNotEmpty
          ? firstName[0]
          : lastName.isNotEmpty
              ? lastName[0]
              : '';
  
  // Convertir en Map pour stockage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
  
  // Construire à partir d'une Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
  
  // Copie de l'objet avec modifications optionnelles
  User copyWith({
    String? firstName,
    String? lastName,
    String? phone,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email,
      phone: phone ?? this.phone,
      createdAt: createdAt,
    );
  }
}