import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/database/app_database.dart' hide User, Shift;
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AppDatabase database;
  final SharedPreferences prefs;

  AuthRepositoryImpl(this.database, this.prefs);

  static const String _sessionKey = 'current_user_id';

  User _mapToUser(dynamic dbUser) {
    if (dbUser == null) throw Exception('User is null');
    return User(
      id: dbUser.id,
      name: dbUser.name,
      email: dbUser.email,
      password: dbUser.password,
      role: dbUser.role,
      pin: dbUser.pin,
      isActive: dbUser.isActive,
      createdAt: dbUser.createdAt,
    );
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final query = database.select(database.users)
        ..where((u) => u.email.equals(email) & u.password.equals(password));
      
      final result = await query.getSingleOrNull();

      if (result != null) {
        if (!result.isActive) {
          return const Left(AuthFailure('User account is inactive'));
        }
        await prefs.setInt(_sessionKey, result.id);
        return Right(_mapToUser(result));
      } else {
        return const Left(AuthFailure('Invalid email or password'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await prefs.remove(_sessionKey);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userId = prefs.getInt(_sessionKey);
      if (userId == null) {
        return const Left(AuthFailure('No user logged in'));
      }

      final query = database.select(database.users)..where((u) => u.id.equals(userId));
      final result = await query.getSingleOrNull();

      if (result != null) {
        return Right(_mapToUser(result));
      } else {
        await prefs.remove(_sessionKey);
        return const Left(AuthFailure('User not found'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword(int userId, String currentPassword, String newPassword) async {
    try {
      final query = database.select(database.users)..where((u) => u.id.equals(userId));
      final user = await query.getSingleOrNull();

      if (user == null) {
        return const Left(AuthFailure('User not found'));
      }

      if (user.password != currentPassword) {
        return const Left(AuthFailure('Incorrect current password'));
      }

      await (database.update(database.users)..where((u) => u.id.equals(userId)))
          .write(UsersCompanion(password: drift.Value(newPassword)));

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await database.select(database.users).get();
      return Right(users.map(_mapToUser).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      final companion = UsersCompanion.insert(
        name: user.name,
        email: user.email,
        password: user.password,
        role: drift.Value(user.role),
        pin: drift.Value(user.pin),
        isActive: drift.Value(user.isActive),
      );
      
      final id = await database.into(database.users).insert(companion);
      
      final newUser = await (database.select(database.users)..where((u) => u.id.equals(id))).getSingle();
      return Right(_mapToUser(newUser));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      final companion = UsersCompanion(
        id: drift.Value(user.id),
        name: drift.Value(user.name),
        email: drift.Value(user.email),
        password: drift.Value(user.password),
        role: drift.Value(user.role),
        pin: drift.Value(user.pin),
        isActive: drift.Value(user.isActive),
      );
      
      await database.update(database.users).replace(companion);
      
      final updatedUser = await (database.select(database.users)..where((u) => u.id.equals(user.id))).getSingle();
      return Right(_mapToUser(updatedUser));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(int id) async {
    try {
      await (database.delete(database.users)..where((u) => u.id.equals(id))).go();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
