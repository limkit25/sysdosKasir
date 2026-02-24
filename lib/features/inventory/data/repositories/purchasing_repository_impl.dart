import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/purchase.dart' as domain;
import '../../domain/entities/purchase_item.dart' as domain;
import '../../domain/entities/stock_change_type_enum.dart';
import '../../domain/repositories/purchasing_repository.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: PurchasingRepository)
class PurchasingRepositoryImpl implements PurchasingRepository {
  final AppDatabase db;

  PurchasingRepositoryImpl(this.db);

  @override
  Future<Either<Failure, List<domain.Purchase>>> getPurchases() async {
    try {
      final rows = await (db.select(db.purchases)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])).get();
      return Right(rows.map((row) => domain.Purchase(
        id: row.id,
        supplierId: row.supplierId,
        date: row.date,
        totalAmount: row.totalAmount,
        invoiceNumber: row.invoiceNumber,
        note: row.note,
      )).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to fetch purchases: $e'));
    }
  }

  @override
  Future<Either<Failure, List<domain.PurchaseItem>>> getPurchaseItems(int purchaseId) async {
    try {
      final rows = await (db.select(db.purchaseItems)..where((t) => t.purchaseId.equals(purchaseId))).get();
      
      final items = await Future.wait(rows.map((row) async {
        final serialRows = await (db.select(db.itemSerials)
          ..where((t) => t.purchaseId.equals(purchaseId) & t.itemId.equals(row.itemId)))
          .get();
        final serials = serialRows.map((s) => s.serialNumber).toList();

        return domain.PurchaseItem(
          id: row.id,
          purchaseId: row.purchaseId,
          itemId: row.itemId,
          quantity: row.quantity,
          cost: row.cost,
          serialNumbers: serials,
        );
      }));

      return Right(items);
    } catch (e) {
      return Left(DatabaseFailure('Failed to fetch purchase items: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> createPurchase(domain.Purchase purchase, List<domain.PurchaseItem> items) async {
    try {
      return await db.transaction(() async {
        // 1. Insert Purchase
        final purchaseId = await db.into(db.purchases).insert(PurchasesCompanion(
          supplierId: Value(purchase.supplierId),
          date: Value(purchase.date),
          totalAmount: Value(purchase.totalAmount),
          invoiceNumber: Value(purchase.invoiceNumber),
          note: Value(purchase.note),
        ));

        // 2. Insert Purchase Items & Update Inventory
        for (final pItem in items) {
          final pItemId = await db.into(db.purchaseItems).insert(PurchaseItemsCompanion(
            purchaseId: Value(purchaseId),
            itemId: Value(pItem.itemId),
            quantity: Value(pItem.quantity),
            cost: Value(pItem.cost),
          ));

          // 2a. Insert Serials if any
          if (pItem.serialNumbers.isNotEmpty) {
             for (final serial in pItem.serialNumbers) {
               await db.into(db.itemSerials).insert(ItemSerialsCompanion(
                 itemId: Value(pItem.itemId),
                 serialNumber: Value(serial),
                 status: const Value(0), // Available
                 purchaseId: Value(purchaseId),
               ));
             }
          }

          // 3. Update Item Stock & Cost (Update Cost to latest buy price)
          final product = await (db.select(db.items)..where((t) => t.id.equals(pItem.itemId))).getSingle();
          final oldStock = product.stock;
          final newStock = oldStock + pItem.quantity;

          await (db.update(db.items)..where((t) => t.id.equals(pItem.itemId))).write(ItemsCompanion(
            stock: Value(newStock),
            cost: Value(pItem.cost), // Update cost to the new purchase price
          ));

          // 4. Create Stock History
          await db.into(db.stockHistories).insert(StockHistoriesCompanion(
            itemId: Value(pItem.itemId),
            oldStock: Value(oldStock),
            newStock: Value(newStock),
            changeAmount: Value(pItem.quantity),
            type: Value(StockChangeType.purchase.name),
            date: Value(DateTime.now()),
            note: Value('Purchase #${purchase.invoiceNumber ?? purchaseId}'),
            serials: Value(pItem.serialNumbers.isNotEmpty ? pItem.serialNumbers.join(',') : null),
          ));
        }

        return Right(purchaseId);
      });
    } catch (e) {
      return Left(DatabaseFailure('Failed to create purchase: $e'));
    }
  }
}
