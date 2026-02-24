import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/promo.dart';

abstract class PromoRepository {
  Future<Either<Failure, List<Promo>>> getPromos();
  Future<Either<Failure, int>> addPromo(Promo promo);
  Future<Either<Failure, void>> updatePromo(Promo promo);
  Future<Either<Failure, void>> deletePromo(int id);
}
