import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/category.dart';
import '../entities/item.dart';
import '../entities/item_composition.dart';
import '../entities/sort_option_enum.dart';
import '../entities/stock_history.dart';
import '../entities/stock_change_type_enum.dart';
import '../entities/item_type_enum.dart';

abstract class InventoryRepository {
  // Categories
  Future<Either<Failure, List<Category>>> getCategories({String? query});
  Future<Either<Failure, int>> addCategory(Category category);
  Future<Either<Failure, void>> updateCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(int id);

  // Items
  Future<Either<Failure, List<Item>>> getItems({int? categoryId, int? parentId, String? query, SortOption sortOption = SortOption.nameAsc, ItemType? itemType});
  Future<Either<Failure, List<ItemType>>> getAvailableItemTypes();
  Future<Either<Failure, Item?>> getItemByBarcode(String barcode);
  Future<Either<Failure, int>> addItem(Item item, {List<ItemComposition>? compositions});
  Future<Either<Failure, int>> addParentWithVariants(Item parent, List<Item> variants);
  Future<Either<Failure, void>> updateItem(Item item, {List<ItemComposition>? compositions});
  Future<Either<Failure, void>> deleteItem(int id);

  // Item Compositions (Bundles/Recipes)
  Future<Either<Failure, void>> addComposition(ItemComposition composition);
  Future<Either<Failure, List<ItemComposition>>> getCompositions(int itemId);
  Future<Either<Failure, void>> deleteComposition(int id);
  
  // Serialized Items
  Future<Either<Failure, void>> addSerials(int itemId, List<String> serials);
  Future<Either<Failure, List<String>>> getAvailableSerials(int itemId);
  // Status: 0=Available, 1=Sold, 2=Defective, 3=Returned
  Future<Either<Failure, void>> updateSerialStatus(String serial, int status, {int? transactionId});
  
  // Stock Management
  Future<Either<Failure, void>> adjustStock({
    required int itemId,
    required int newStock,
    required String note,
    required StockChangeType type,
    List<String>? serials,
  });
  Future<Either<Failure, List<StockHistory>>> getStockHistory(int itemId, {DateTime? startDate, DateTime? endDate});
}
