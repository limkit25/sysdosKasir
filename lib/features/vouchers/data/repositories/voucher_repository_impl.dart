import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db_data;
import '../../../../core/error/failures.dart';
import '../../domain/entities/voucher.dart';
import '../../domain/repositories/voucher_repository.dart';

@LazySingleton(as: VoucherRepository)
class VoucherRepositoryImpl implements VoucherRepository {
  final db_data.AppDatabase _db;

  VoucherRepositoryImpl(this._db);

  @override
  Future<Either<Failure, List<Voucher>>> getVouchers() async {
    try {
      final rows = await _db.select(_db.vouchers).get();
      final vouchers = rows.map((row) => _mapToEntity(row)).toList();
      return Right(vouchers);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Voucher>>> getActiveVouchers() async {
    try {
      final query = _db.select(_db.vouchers)..where((v) => v.isActive.equals(true));
      final rows = await query.get();
      final vouchers = rows.map((row) => _mapToEntity(row)).toList();
      return Right(vouchers);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> saveVoucher(Voucher voucher) async {
    try {
      final companion = db_data.VouchersCompanion(
        name: Value(voucher.name),
        amount: Value(voucher.amount),
        isActive: Value(voucher.isActive),
        createdDate: Value(voucher.createdDate),
      );
      final id = await _db.into(_db.vouchers).insert(companion);
      return Right(id);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateVoucher(Voucher voucher) async {
    try {
      if (voucher.id == null) {
        return Left(CacheFailure('Voucher ID is required for update'));
      }
      final companion = db_data.VouchersCompanion(
        name: Value(voucher.name),
        amount: Value(voucher.amount),
        isActive: Value(voucher.isActive),
        createdDate: Value(voucher.createdDate),
      );
      await (_db.update(_db.vouchers)..where((v) => v.id.equals(voucher.id!)))
          .write(companion);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVoucher(int id) async {
    try {
      await (_db.delete(_db.vouchers)..where((v) => v.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleActive(int id, bool isActive) async {
    try {
      await (_db.update(_db.vouchers)..where((v) => v.id.equals(id)))
          .write(db_data.VouchersCompanion(isActive: Value(isActive)));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Voucher _mapToEntity(db_data.Voucher row) {
    return Voucher(
      id: row.id,
      name: row.name,
      amount: row.amount,
      isActive: row.isActive,
      createdDate: row.createdDate,
    );
  }
}
