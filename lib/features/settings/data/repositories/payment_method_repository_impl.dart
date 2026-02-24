import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_method_repository.dart';

@LazySingleton(as: PaymentMethodRepository)
class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final db.AppDatabase _db;

  PaymentMethodRepositoryImpl(this._db);

  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final rows = await _db.select(_db.paymentMethods).get();
      final methods = rows.map((r) => PaymentMethod(
        id: r.id,
        name: r.name,
        isActive: r.isActive,
        isFixPayment: r.isFixPayment,
      )).toList();
      return Right(methods);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPaymentMethod(String name) async {
    try {
      await _db.into(_db.paymentMethods).insert(db.PaymentMethodsCompanion(
        name: Value(name),
        isActive: const Value(true),
      ));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod(int id) async {
    try {
      await (_db.delete(_db.paymentMethods)..where((t) => t.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> togglePaymentMethod(int id, bool isActive) async {
    try {
      await (_db.update(_db.paymentMethods)..where((t) => t.id.equals(id))).write(
        db.PaymentMethodsCompanion(isActive: Value(isActive)),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFixPayment(int id, bool isFixPayment) async {
    try {
      await (_db.update(_db.paymentMethods)..where((t) => t.id.equals(id))).write(
        db.PaymentMethodsCompanion(isFixPayment: Value(isFixPayment)),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
