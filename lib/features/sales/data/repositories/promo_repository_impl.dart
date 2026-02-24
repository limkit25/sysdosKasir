import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart' as db_data;
import '../../../../core/error/failures.dart';
import '../../domain/entities/promo.dart';
import '../../domain/repositories/promo_repository.dart';

@LazySingleton(as: PromoRepository)
class PromoRepositoryImpl implements PromoRepository {
  final db_data.AppDatabase _db;

  PromoRepositoryImpl(this._db);

  @override
  Future<Either<Failure, List<Promo>>> getPromos() async {
    try {
      final result = await _db.select(_db.promos).get();
      final promos = result.map((row) => Promo(
        id: row.id,
        name: row.name,
        type: row.type,
        value: row.value,
        isActive: row.isActive,
        minPurchase: row.minPurchase ?? 0,
        maxDiscount: row.maxDiscount ?? 0,
      )).toList();
      return Right(promos);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addPromo(Promo promo) async {
    try {
      final companion = db_data.PromosCompanion(
        name: Value(promo.name),
        type: Value(promo.type),
        value: Value(promo.value),
        isActive: Value(promo.isActive),
        minPurchase: Value(promo.minPurchase),
        maxDiscount: Value(promo.maxDiscount),
      );
      final id = await _db.into(_db.promos).insert(companion);
      return Right(id);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePromo(Promo promo) async {
     try {
      final companion = db_data.PromosCompanion(
        id: Value(promo.id!),
        name: Value(promo.name),
        type: Value(promo.type),
        value: Value(promo.value),
        isActive: Value(promo.isActive),
        minPurchase: Value(promo.minPurchase),
        maxDiscount: Value(promo.maxDiscount),
      );
      await _db.update(_db.promos).replace(companion);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePromo(int id) async {
    try {
      await (_db.delete(_db.promos)..where((tbl) => tbl.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
       return Left(CacheFailure(e.toString()));
    }
  }
}
