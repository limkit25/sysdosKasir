import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db_data;
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_item.dart';
import '../../domain/entities/payment_detail.dart';
import '../../domain/repositories/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final db_data.AppDatabase _db;

  TransactionRepositoryImpl(this._db);

  @override
  Future<Either<Failure, int>> saveTransaction(Transaction transaction) async {
    return _db.transaction(() async {
      try {
        // 1. Insert Transaction Header
        final transactionCompanion = db_data.TransactionsCompanion(
          transactionDate: Value(transaction.dateTime),
          totalAmount: Value(transaction.totalAmount),
          paymentAmount: Value(transaction.paymentAmount),
          changeAmount: Value(transaction.changeAmount),
          paymentMethod: Value(transaction.paymentMethod),
          discountAmount: Value(transaction.discountAmount),
          taxAmount: Value(transaction.taxAmount),
          serviceFeeAmount: Value(transaction.serviceFeeAmount),
          status: Value(transaction.status),
          // New Fields
          customerId: Value(transaction.customerId),
          tableNumber: Value(transaction.tableNumber),
          pax: Value(transaction.pax),
          note: Value(transaction.note),
          isDebt: Value(transaction.isDebt),
          guestName: Value(transaction.guestName),
          paymentDetails: Value(PaymentDetailsHelper.encode(transaction.splitPayments)),
        );

        final transactionId = await _db.into(_db.transactions).insert(transactionCompanion);

        // 2. Insert Items & Deduct Stock
        await _insertItemsAndDeductStock(transactionId, transaction.items, status: transaction.status);
          
        return Right(transactionId);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> updateTransaction(Transaction transaction) async {
    return _db.transaction(() async {
      try {
        if (transaction.id == null) throw Exception("Transaction ID is required for update");

        // 1. Restore Stock from OLD Items (as if we are deleting them)
        await _restoreStockFromTransaction(transaction.id!, "Void (Update Order #${transaction.id})");

        // 2. Delete OLD Items
        await (_db.delete(_db.transactionItems)..where((t) => t.transactionId.equals(transaction.id!))).go();

        // 3. Update Header
        final transactionCompanion = db_data.TransactionsCompanion(
          transactionDate: Value(transaction.dateTime),
          totalAmount: Value(transaction.totalAmount),
          paymentAmount: Value(transaction.paymentAmount),
          changeAmount: Value(transaction.changeAmount),
          paymentMethod: Value(transaction.paymentMethod),
          discountAmount: Value(transaction.discountAmount),
          taxAmount: Value(transaction.taxAmount),
          serviceFeeAmount: Value(transaction.serviceFeeAmount),
          status: Value(transaction.status),
           // New Fields
           customerId: Value(transaction.customerId),
          tableNumber: Value(transaction.tableNumber),
          pax: Value(transaction.pax),
          note: Value(transaction.note),
          isDebt: Value(transaction.isDebt),
          guestName: Value(transaction.guestName),
          paymentDetails: Value(PaymentDetailsHelper.encode(transaction.splitPayments)),
        );

        await (_db.update(_db.transactions)..where((t) => t.id.equals(transaction.id!))).write(transactionCompanion);

        // 4. Insert NEW Items & Deduct Stock
        await _insertItemsAndDeductStock(transaction.id!, transaction.items, status: transaction.status);

        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, List<Transaction>>> getPendingTransactions() async {
    try {
      final query = _db.select(_db.transactions)..where((t) => t.status.equals('pending'));
      final transactionRows = await query.get();
      return _mapTransactions(transactionRows);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getDebtTransactions() async {
    try {
      final query = _db.select(_db.transactions)..where((t) => t.isDebt.equals(true));
      final transactionRows = await query.get();
      return _mapTransactions(transactionRows);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Transaction>>> _mapTransactions(List<db_data.Transaction> transactionRows) async {
      List<Transaction> transactions = [];

      for (final row in transactionRows) {
        // Fetch items for this transaction
        final itemRows = await (_db.select(_db.transactionItems)..where((t) => t.transactionId.equals(row.id))).get();
        final List<TransactionItem> transactionItems = [];

        for (final itemRow in itemRows) {
           final serials = await (_db.select(_db.itemSerials)..where((t) => t.transactionId.equals(row.id) & t.itemId.equals(itemRow.itemId))).get();
           final serialNumbers = serials.map((s) => s.serialNumber).toList();

           // Fetch product name
           final product = await (_db.select(_db.items)..where((t) => t.id.equals(itemRow.itemId))).getSingleOrNull();
           final itemName = product?.name ?? 'Unknown Item';

           transactionItems.add(TransactionItem(
             itemId: itemRow.itemId,
             quantity: itemRow.quantity,
             price: itemRow.price,
             cost: itemRow.cost,
             serialNumbers: serialNumbers,
             itemName: itemName,
           ));
        }

        transactions.add(Transaction(
          id: row.id,
          dateTime: row.transactionDate,
          totalAmount: row.totalAmount,
          paymentAmount: row.paymentAmount,
          changeAmount: row.changeAmount,
          paymentMethod: row.paymentMethod,
          discountAmount: row.discountAmount,
          taxAmount: row.taxAmount,
          serviceFeeAmount: row.serviceFeeAmount,
          status: row.status,
          customerId: row.customerId,
          tableNumber: row.tableNumber,
          pax: row.pax,
          note: row.note,
          isDebt: row.isDebt,
          guestName: row.guestName,
          items: transactionItems,
        ));
      }
      return Right(transactions);
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(int id) async {
    return _db.transaction(() async {
      try {
        // 1. Restore Stock
        await _restoreStockFromTransaction(id, "Void (Order #$id)");

        // 2. Delete Transaction Items
        await (_db.delete(_db.transactionItems)..where((t) => t.transactionId.equals(id))).go();

        // 3. Delete Transaction
        await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();

        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> payDebt(int transactionId, int paymentAmount) async {
    return _db.transaction(() async {
      try {
        final transaction = await (_db.select(_db.transactions)..where((t) => t.id.equals(transactionId))).getSingleOrNull();
        if (transaction == null) throw Exception("Transaction not found");

        final currentPaid = transaction.paymentAmount;
        final total = transaction.totalAmount;
        final newPaid = currentPaid + paymentAmount;
        
        // Determine status
        final newStatus = newPaid >= total ? 'success' : transaction.status;
        final newIsDebt = true; // Always true, so we have a history of it being a debt.

        await (_db.update(_db.transactions)..where((t) => t.id.equals(transactionId))).write(
          db_data.TransactionsCompanion(
            paymentAmount: Value(newPaid),
            status: Value(newStatus),
            isDebt: Value(newIsDebt),
            changeAmount: Value(newPaid > total ? newPaid - total : 0),
          ),
        );
        
        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }

  // --- Helper Methods ---

  Future<void> _insertItemsAndDeductStock(int transactionId, List<TransactionItem> items, {required String status}) async {
      final isPending = status == 'pending';
      final historyType = isPending ? 'hold' : 'sale'; 
      // English Language
      final notePrefix = isPending ? 'Hold (Pending)' : 'Sold'; 

      for (final item in items) {
          final itemCompanion = db_data.TransactionItemsCompanion(
            transactionId: Value(transactionId),
            itemId: Value(item.itemId),
            quantity: Value(item.quantity),
            price: Value(item.price),
            cost: Value(item.cost),
          );
          await _db.into(_db.transactionItems).insert(itemCompanion);
          
          // Update Stock
          final productRow = await (_db.select(_db.items)..where((tbl) => tbl.id.equals(item.itemId))).getSingleOrNull();
          
          if (productRow != null) {
             // Handle Serialized Items
             if (item.serialNumbers.isNotEmpty) {
               for (final serial in item.serialNumbers) {
                 await (_db.update(_db.itemSerials)..where((tbl) => tbl.serialNumber.equals(serial))).write(
                   db_data.ItemSerialsCompanion(
                     status: const Value(1), // Sold
                     transactionId: Value(transactionId),
                     dateSold: Value(DateTime.now()),
                   ),
                 );
               }
             }

             if (productRow.itemType == 'service') {
               // Skip stock update
             } else if (productRow.itemType == 'bundle' || productRow.itemType == 'recipe') {
               // Deduct stock from components
               final compositions = await (_db.select(_db.itemCompositions)..where((tbl) => tbl.parentItemId.equals(item.itemId))).get();
               for (final comp in compositions) {
                 final childItem = await (_db.select(_db.items)..where((tbl) => tbl.id.equals(comp.childItemId))).getSingleOrNull();
                 if (childItem != null && childItem.isTrackStock) {
                   final deduction = comp.quantity * item.quantity;
                   final oldStock = childItem.stock;
                   final newStock = oldStock - deduction;
                   
                   await (_db.update(_db.items)..where((tbl) => tbl.id.equals(comp.childItemId))).write(
                     db_data.ItemsCompanion(stock: Value(newStock)),
                   );

                   await _db.into(_db.stockHistories).insert(
                     db_data.StockHistoriesCompanion(
                       itemId: Value(comp.childItemId),
                       oldStock: Value(oldStock),
                       newStock: Value(newStock),
                       changeAmount: Value(-deduction),
                       type: Value(historyType),
                       date: Value(DateTime.now()),
                       note: Value('$notePrefix #$transactionId (Bundle: ${productRow.name})'),
                     ),
                   );
                 }
               }
             } else if (productRow.isTrackStock) {
               // Deduct Standard Stock
               final oldStock = productRow.stock;
               final newStock = oldStock - item.quantity;
               
               await (_db.update(_db.items)..where((tbl) => tbl.id.equals(item.itemId))).write(
                 db_data.ItemsCompanion(stock: Value(newStock)),
               );

               await _db.into(_db.stockHistories).insert(
                 db_data.StockHistoriesCompanion(
                   itemId: Value(item.itemId),
                   oldStock: Value(oldStock),
                   newStock: Value(newStock),
                   changeAmount: Value(-item.quantity),
                   type: Value(historyType),
                   date: Value(DateTime.now()),
                   note: Value('$notePrefix #$transactionId'),
                   serials: Value(item.serialNumbers.isNotEmpty ? item.serialNumbers.join(',') : null),
                 ),
               );
             }
          }
        }
  }

  Future<void> _restoreStockFromTransaction(int transactionId, String notePrefix) async {
      final items = await (_db.select(_db.transactionItems)..where((t) => t.transactionId.equals(transactionId))).get();
      
      for (final item in items) {
          final productRow = await (_db.select(_db.items)..where((tbl) => tbl.id.equals(item.itemId))).getSingleOrNull();
          if (productRow == null) continue;

          // Restore Serialized Items
          final serials = await (_db.select(_db.itemSerials)..where((t) => t.transactionId.equals(transactionId) & t.itemId.equals(item.itemId))).get();
          for (final serial in serials) {
             await (_db.update(_db.itemSerials)..where((tbl) => tbl.id.equals(serial.id))).write(
               db_data.ItemSerialsCompanion(
                 status: const Value(0), // Available
                 transactionId: const Value(null),
                 dateSold: const Value(null),
               ),
             );
          }

          if (productRow.itemType == 'bundle' || productRow.itemType == 'recipe') {
             // Restore components
             final compositions = await (_db.select(_db.itemCompositions)..where((tbl) => tbl.parentItemId.equals(item.itemId))).get();
             for (final comp in compositions) {
               final childItem = await (_db.select(_db.items)..where((tbl) => tbl.id.equals(comp.childItemId))).getSingleOrNull();
               if (childItem != null && childItem.isTrackStock) {
                 final restoration = comp.quantity * item.quantity;
                 final oldStock = childItem.stock;
                 final newStock = oldStock + restoration;
                 
                 await (_db.update(_db.items)..where((tbl) => tbl.id.equals(comp.childItemId))).write(
                   db_data.ItemsCompanion(stock: Value(newStock)),
                 );
                 
                 await _db.into(_db.stockHistories).insert(
                   db_data.StockHistoriesCompanion(
                     itemId: Value(comp.childItemId),
                     oldStock: Value(oldStock),
                     newStock: Value(newStock),
                     changeAmount: Value(restoration),
                     type: const Value('adjustment'),
                     date: Value(DateTime.now()),
                     note: Value('$notePrefix (Bundle: ${productRow.name})'),
                   ),
                 );
               }
             }
          } else if (productRow.isTrackStock) {
              // Restore Standard
              final oldStock = productRow.stock;
              final newStock = oldStock + item.quantity;

              await (_db.update(_db.items)..where((tbl) => tbl.id.equals(item.itemId))).write(
                db_data.ItemsCompanion(stock: Value(newStock)),
              );

              await _db.into(_db.stockHistories).insert(
                db_data.StockHistoriesCompanion(
                  itemId: Value(item.itemId),
                  oldStock: Value(oldStock),
                  newStock: Value(newStock),
                  changeAmount: Value(item.quantity),
                  type: const Value('adjustment'),
                  date: Value(DateTime.now()),
                  note: Value(notePrefix),
                ),
              );
          }
       }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getTurnoverStats() async {
    try {
      final now = DateTime.now();
      
      final startOfToday = DateTime(now.year, now.month, now.day);
      final startOfThisMonth = DateTime(now.year, now.month, 1);
      final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
      final endOfLastMonth = DateTime(now.year, now.month, 0, 23, 59, 59);

      Future<int> getSum(DateTime start, DateTime? end) async {
        final totalAmountSum = _db.transactions.totalAmount.sum();
        final query = _db.selectOnly(_db.transactions)..addColumns([totalAmountSum]);
        
        // FIX: Exclude pending transactions from stats!
        query.where(_db.transactions.status.equals('success')); 

        query.where(_db.transactions.transactionDate.isBiggerOrEqualValue(start));
        if (end != null) {
          query.where(_db.transactions.transactionDate.isSmallerOrEqualValue(end));
        }

        final result = await query.getSingle();
        return result.read(totalAmountSum) ?? 0;
      }

      final today = await getSum(startOfToday, null);
      final thisMonth = await getSum(startOfThisMonth, null);
      final lastMonth = await getSum(startOfLastMonth, endOfLastMonth);

      return Right({
        'today': today,
        'thisMonth': thisMonth,
        'lastMonth': lastMonth,
      });

    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
