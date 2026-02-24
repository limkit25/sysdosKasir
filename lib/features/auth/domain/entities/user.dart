import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String? pin;
  final bool isActive;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.pin,
    required this.isActive,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, password, role, pin, isActive, createdAt];
}
