import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/purchase.dart';
import '../entities/purchase_item.dart';

abstract class PurchasingRepository {
  Future<Either<Failure, List<Purchase>>> getPurchases();
  Future<Either<Failure, List<PurchaseItem>>> getPurchaseItems(int purchaseId);
  Future<Either<Failure, int>> createPurchase(Purchase purchase, List<PurchaseItem> items);
}
