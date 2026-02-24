import 'package:equatable/equatable.dart';
import 'item_type_enum.dart';

class Item extends Equatable {
  final int? id;
  final int categoryId;
  final String name;
  final String? barcode;
  final int price;
  final int cost;
  final int stock;
  final bool isTrackStock;
  final String? imagePath;
  final bool isVisible;
  final int discount;
  final ItemType itemType;
  final int? parentId; // For Variants
  final int weight; // in grams
  final String unit; // pcs, kg, etc.
  final String? purchaseUnit; // e.g. Dus, Pack
  final int conversionFactor; // e.g. 24

  const Item({
    this.id,
    required this.categoryId,
    required this.name,
    this.barcode,
    required this.price,
    required this.cost,
    this.stock = 0,
    this.isTrackStock = true,
    this.imagePath,
    this.isVisible = true,
    this.discount = 0,
    this.itemType = ItemType.single,
    this.parentId,
    this.weight = 0,
    this.unit = 'pcs',
    this.purchaseUnit,
    this.conversionFactor = 1,
  });

  @override
  List<Object?> get props => [id, categoryId, name, barcode, price, cost, stock, isTrackStock, imagePath, isVisible, discount, itemType, parentId, weight, unit, purchaseUnit, conversionFactor];
}
