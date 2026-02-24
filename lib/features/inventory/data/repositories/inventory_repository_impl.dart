import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db_data;
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_composition.dart';
import '../../domain/entities/item_type_enum.dart';
import '../../domain/entities/sort_option_enum.dart';
import '../../domain/entities/stock_history.dart';
import '../../domain/entities/stock_change_type_enum.dart';
import '../../domain/repositories/inventory_repository.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final db_data.AppDatabase _db;

  InventoryRepositoryImpl(this._db);

  @override
  Future<Either<Failure, int>> addCategory(Category category) async {
    try {
      final companion = db_data.CategoriesCompanion(
        name: Value(category.name),
        description: Value(category.description),
      );
      final id = await _db.into(_db.categories).insert(companion);
      return Right(id);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addItem(Item item, {List<ItemComposition>? compositions}) async {
    return _db.transaction(() async {
      try {
        final companion = db_data.ItemsCompanion(
          categoryId: Value(item.categoryId),
          name: Value(item.name),
          barcode: Value(item.barcode),
          price: Value(item.price),
          cost: Value(item.cost),
          stock: Value(item.stock),
          isTrackStock: Value(item.isTrackStock),
          imagePath: Value(item.imagePath),
          isVisible: Value(item.isVisible),
          discount: Value(item.discount),
          itemType: Value(item.itemType.name), // Convert Enum to String
          parentId: Value(item.parentId),
          weight: Value(item.weight),
          unit: Value(item.unit),
          purchaseUnit: Value(item.purchaseUnit),
          conversionFactor: Value(item.conversionFactor),
        );
        final id = await _db.into(_db.items).insert(companion);

        if (compositions != null && compositions.isNotEmpty) {
           for (final comp in compositions) {
             await _db.into(_db.itemCompositions).insert(db_data.ItemCompositionsCompanion(
               parentItemId: Value(id),
               childItemId: Value(comp.childItemId),
               quantity: Value(comp.quantity),
             ));
           }
        }

        return Right(id);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, int>> addParentWithVariants(Item parent, List<Item> variants) async {
    return _db.transaction(() async {
      try {
        // 1. Insert Parent Item
        final parentCompanion = db_data.ItemsCompanion(
          categoryId: Value(parent.categoryId),
          name: Value(parent.name),
          barcode: Value(parent.barcode),
          price: Value(parent.price),
          cost: Value(parent.cost),
          stock: const Value(0), // Parent has no direct stock
          isTrackStock: const Value(false), // Parent doesn't track stock
          imagePath: Value(parent.imagePath),
          isVisible: Value(parent.isVisible),
          discount: Value(parent.discount),
          itemType: Value(ItemType.variant.name),
          weight: Value(parent.weight),
          unit: Value(parent.unit),
        );
        final parentId = await _db.into(_db.items).insert(parentCompanion);

        // 2. Insert Variants
        for (final variant in variants) {
          final variantCompanion = db_data.ItemsCompanion(
            categoryId: Value(parent.categoryId), // Inherit category
            name: Value(variant.name),
            barcode: Value(variant.barcode),
            price: Value(variant.price),
            cost: Value(variant.cost),
            stock: Value(variant.stock),
            isTrackStock: const Value(true), // Variants track stock
            imagePath: Value(variant.imagePath ?? parent.imagePath), // Inherit image if null
            isVisible: const Value(true), // Always visible? Or inherit?
            discount: Value(variant.discount),
            itemType: Value(ItemType.single.name), // Variants are single items linked to parent
            parentId: Value(parentId), // Link to Parent
            weight: Value(variant.weight),
            unit: Value(variant.unit),
          );
          await _db.into(_db.items).insert(variantCompanion);
        }

        return Right(parentId);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await (_db.delete(_db.categories)..where((tbl) => tbl.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(int id) async {
    try {
      await (_db.delete(_db.items)..where((tbl) => tbl.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories({String? query}) async {
    try {
      final statement = _db.select(_db.categories);
      if (query != null && query.isNotEmpty) {
        statement.where((tbl) => tbl.name.lower().contains(query.toLowerCase()));
      }
      final rows = await statement.get();
      final categories = rows
          .map((row) => Category(
                id: row.id,
                name: row.name,
                description: row.description,
              ))
          .toList();
      return Right(categories);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Item?>> getItemByBarcode(String barcode) async {
    try {
      final row = await (_db.select(_db.items)..where((tbl) => tbl.barcode.equals(barcode))).getSingleOrNull();
      if (row == null) return const Right(null);
      return Right(Item(
        id: row.id,
        categoryId: row.categoryId,
        name: row.name,
        barcode: row.barcode,
        price: row.price,
        cost: row.cost,
        stock: row.stock,
        isTrackStock: row.isTrackStock,
        imagePath: row.imagePath,
        isVisible: row.isVisible,
        discount: row.discount,
        itemType: ItemType.values.firstWhere(
            (e) => e.name == row.itemType, orElse: () => ItemType.single), // Convert String to Enum
        parentId: row.parentId,
        weight: row.weight,
        unit: row.unit,
      ));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemType>>> getAvailableItemTypes() async {
    try {
      final query = _db.selectOnly(_db.items, distinct: true)
        ..addColumns([_db.items.itemType]);
      
      final rows = await query.get();
      
      final types = rows.map((row) {
        final typeStr = row.read(_db.items.itemType);
        return ItemType.values.firstWhere(
          (e) => e.name == typeStr,
          orElse: () => ItemType.single,
        );
      }).toList();

      // Ensure 'Single' is always present if list is empty? Or just return what's there.
      // Usually we want at least 'Single'. But let's stick to truthful data.
      
      return Right(types);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getItems({int? categoryId, int? parentId, String? query, SortOption sortOption = SortOption.nameAsc, ItemType? itemType}) async {
    try {
      final statement = _db.select(_db.items);
      
      // Filtering
      if (categoryId != null) {
        statement.where((tbl) => tbl.categoryId.equals(categoryId));
      }
      if (parentId != null) {
        statement.where((tbl) => tbl.parentId.equals(parentId));
      }
      if (query != null && query.isNotEmpty) {
        statement.where((tbl) => tbl.name.lower().contains(query.toLowerCase()));
      }
      if (itemType != null) {
        statement.where((tbl) => tbl.itemType.equals(itemType.name));
      }

      // Sorting
      switch (sortOption) {
        case SortOption.nameAsc:
          statement.orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)]);
          break;
        case SortOption.nameDesc:
          statement.orderBy([(tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.desc)]);
          break;
        case SortOption.priceLow:
          statement.orderBy([(tbl) => OrderingTerm(expression: tbl.price, mode: OrderingMode.asc)]);
          break;
        case SortOption.priceHigh:
          statement.orderBy([(tbl) => OrderingTerm(expression: tbl.price, mode: OrderingMode.desc)]);
          break;
        case SortOption.stockLow:
          statement.orderBy([(tbl) => OrderingTerm(expression: tbl.stock, mode: OrderingMode.asc)]);
          break;
        case SortOption.stockHigh:
          statement.orderBy([(tbl) => OrderingTerm(expression: tbl.stock, mode: OrderingMode.desc)]);
          break;
        case SortOption.newest:
          statement.orderBy([(tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.desc)]);
          break;
      }

      final rows = await statement.get();
      final items = rows
          .map((row) => Item(
                id: row.id,
                categoryId: row.categoryId,
                name: row.name,
                barcode: row.barcode,
                price: row.price,
                cost: row.cost,
                stock: row.stock,
                isTrackStock: row.isTrackStock,
                imagePath: row.imagePath,
                isVisible: row.isVisible,
                discount: row.discount,
                itemType: ItemType.values.firstWhere(
                    (e) => e.name == row.itemType, orElse: () => ItemType.single), // Convert String to Enum
                parentId: row.parentId,
                weight: row.weight,
                unit: row.unit,
              ))
          .toList();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(Category category) async {
    try {
      await (_db.update(_db.categories)..where((tbl) => tbl.id.equals(category.id!))).write(
        db_data.CategoriesCompanion(
          name: Value(category.name),
          description: Value(category.description),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateItem(Item item, {List<ItemComposition>? compositions}) async {
    return _db.transaction(() async {
      try {
        await (_db.update(_db.items)..where((tbl) => tbl.id.equals(item.id!))).write(
          db_data.ItemsCompanion(
            categoryId: Value(item.categoryId),
            name: Value(item.name),
            barcode: Value(item.barcode),
            price: Value(item.price),
            cost: Value(item.cost),
            stock: Value(item.stock),
            isTrackStock: Value(item.isTrackStock),
            imagePath: Value(item.imagePath),
            isVisible: Value(item.isVisible),
            discount: Value(item.discount),
            itemType: Value(item.itemType.name),
            parentId: Value(item.parentId),
            weight: Value(item.weight),
            unit: Value(item.unit),
            purchaseUnit: Value(item.purchaseUnit),
            conversionFactor: Value(item.conversionFactor),
          ),
        );

        if (compositions != null) {
          // Delete old compositions
          await (_db.delete(_db.itemCompositions)..where((tbl) => tbl.parentItemId.equals(item.id!))).go();
          // Insert new ones
          for (final comp in compositions) {
             await _db.into(_db.itemCompositions).insert(db_data.ItemCompositionsCompanion(
               parentItemId: Value(item.id!),
               childItemId: Value(comp.childItemId),
               quantity: Value(comp.quantity),
             ));
           }
        }
        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }
  @override
  Future<Either<Failure, void>> addComposition(ItemComposition composition) async {
    try {
      final companion = db_data.ItemCompositionsCompanion(
        parentItemId: Value(composition.parentItemId),
        childItemId: Value(composition.childItemId),
        quantity: Value(composition.quantity),
      );
      await _db.into(_db.itemCompositions).insert(companion);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemComposition>>> getCompositions(int parentItemId) async {
    try {
      final rows = await (_db.select(_db.itemCompositions)..where((tbl) => tbl.parentItemId.equals(parentItemId))).get();
      final compositions = rows
          .map((row) => ItemComposition(
                id: row.id,
                parentItemId: row.parentItemId,
                childItemId: row.childItemId,
                quantity: row.quantity,
              ))
          .toList();
      return Right(compositions);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComposition(int id) async {
    try {
      await (_db.delete(_db.itemCompositions)..where((tbl) => tbl.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> adjustStock({
    required int itemId,
    required int newStock,
    required String note,
    required StockChangeType type,
    List<String>? serials,
  }) async {
    return _db.transaction(() async {
      try {
        // 1. Get current stock
        final item = await (_db.select(_db.items)..where((t) => t.id.equals(itemId))).getSingle();
        final oldStock = item.stock;
        final changeAmount = newStock - oldStock;

        // 2. Handle Serials if provided
        if (serials != null) {
           if (type == StockChangeType.opname) {
             // Opname: Replace current available serials with new list?
             // Or intelligently find diff?
             // For simplicity/safety in opname:
             // 1. Mark all current available as 'Lost/Audit' (or just verify against new list)
             // 2. Insert new ones
             // Actually, Opname usually means "This is what I have".
             
             // Strategy:
             // Get current available serials
             final currentSerials = await (_db.select(_db.itemSerials)
               ..where((t) => t.itemId.equals(itemId) & t.status.equals(0))).get();
             final currentSerialSet = currentSerials.map((e) => e.serialNumber).toSet();
             final newSerialSet = serials.toSet();

             // Serials to Remove (In DB but not in Opname) -> Mark as Adjusted Out / Lost
             final toRemove = currentSerialSet.difference(newSerialSet);
             for (final s in toRemove) {
                await (_db.update(_db.itemSerials)..where((t) => t.serialNumber.equals(s))).write(
                  db_data.ItemSerialsCompanion(
                    status: const Value(2), // Defective/Lost (Using 2 for now, maybe need explicit 'Lost')
                    dateSold: Value(DateTime.now()), // dateRemoved
                  ),
                );
             }

             // Serials to Add (In Opname but not in DB) -> Insert
             final toAdd = newSerialSet.difference(currentSerialSet);
             for (final s in toAdd) {
                // Check if it exists but was sold/defective? Reactivate?
                // For now, assume fresh insert or error if duplicate. 
                // unique constraint will fail if exists.
                // Let's check existence first to be safe or use insertOnConflictUpdate if supported,
                // but we strictly want "Available" status.
                // detailed check:
                final existing = await (_db.select(_db.itemSerials)..where((t) => t.serialNumber.equals(s) & t.itemId.equals(itemId))).getSingleOrNull();
                if (existing != null) {
                  // Reactivate if not available?
                  if (existing.status != 0) {
                     await (_db.update(_db.itemSerials)..where((t) => t.id.equals(existing.id))).write(
                       const db_data.ItemSerialsCompanion(status: Value(0), dateSold: Value.absent()),
                     );
                  }
                } else {
                   await _db.into(_db.itemSerials).insert(
                     db_data.ItemSerialsCompanion(
                       itemId: Value(itemId),
                       serialNumber: Value(s),
                       status: const Value(0),
                     )
                   );
                }
             }

           } else {
             // Adjustment (Add/Subtract)
             if (changeAmount > 0) {
               // Adding Stock -> Insert Serials
               for (final s in serials) {
                 await _db.into(_db.itemSerials).insert(
                   db_data.ItemSerialsCompanion(
                     itemId: Value(itemId),
                     serialNumber: Value(s),
                     status: const Value(0),
                   )
                 );
               }
             } else if (changeAmount < 0) {
               // Removing Stock -> Mark Serials as Defective/Removed
               for (final s in serials) {
                 await (_db.update(_db.itemSerials)..where((t) => t.serialNumber.equals(s))).write(
                    db_data.ItemSerialsCompanion(
                      status: const Value(2), // Defective/Returned/Adjusted Out
                      dateSold: Value(DateTime.now()),
                    ),
                  );
               }
             }
           }
        }

        // 3. Update Item Stock
        await (_db.update(_db.items)..where((t) => t.id.equals(itemId))).write(
          db_data.ItemsCompanion(stock: Value(newStock)),
        );

        // 4. Log History
        // Check for custom note or default
        String historyNote = note;
        if (historyNote.isEmpty) {
          historyNote = type == StockChangeType.opname ? 'Opname' : 'Adjustment';
        }

        await _db.into(_db.stockHistories).insert(
          db_data.StockHistoriesCompanion(
            itemId: Value(itemId),
            oldStock: Value(oldStock),
            newStock: Value(newStock),
            changeAmount: Value(changeAmount),
            type: Value(type.name),
            date: Value(DateTime.now()),
            note: Value(historyNote),
            serials: Value(serials?.join(',')),
          ),
        );

        return const Right(null);
      } catch (e) {
        return Left(CacheFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, List<StockHistory>>> getStockHistory(int itemId, {DateTime? startDate, DateTime? endDate}) async {
    try {
      final statement = _db.select(_db.stockHistories)
        ..where((t) => t.itemId.equals(itemId));

      if (startDate != null) {
        statement.where((t) => t.date.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        statement.where((t) => t.date.isSmallerOrEqualValue(endOfDay));
      }

      final rows = await (statement
            ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
          .get();

      final history = rows.map((row) {
        return StockHistory(
          id: row.id,
          itemId: row.itemId,
          oldStock: row.oldStock,
          newStock: row.newStock,
          changeAmount: row.changeAmount,
          type: StockChangeType.values.firstWhere((e) => e.name == row.type, orElse: () => StockChangeType.adjustment),
          date: row.date,
          note: row.note,
          serials: row.serials,
        );
      }).toList();

      return Right(history);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> addSerials(int itemId, List<String> serials) async {
    try {
      await _db.batch((batch) {
        for (final serial in serials) {
          batch.insert(
            _db.itemSerials,
            db_data.ItemSerialsCompanion(
              itemId: Value(itemId),
              serialNumber: Value(serial),
              status: const Value(0), // Available
            ),
          );
        }
      });
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableSerials(int itemId) async {
    try {
      final rows = await (_db.select(_db.itemSerials)
            ..where((tbl) => tbl.itemId.equals(itemId) & tbl.status.equals(0)))
          .get();
      return Right(rows.map((r) => r.serialNumber).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSerialStatus(String serial, int status, {int? transactionId}) async {
    try {
      await (_db.update(_db.itemSerials)..where((tbl) => tbl.serialNumber.equals(serial))).write(
        db_data.ItemSerialsCompanion(
          status: Value(status),
          transactionId: Value(transactionId),
          dateSold: status == 1 ? Value(DateTime.now()) : const Value.absent(),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
