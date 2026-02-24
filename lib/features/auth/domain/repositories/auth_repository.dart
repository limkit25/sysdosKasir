import '../entities/user.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, Unit>> changePassword(int userId, String currentPassword, String newPassword);
  
  // User Management
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> createUser(User user);
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, Unit>> deleteUser(int id);
}
