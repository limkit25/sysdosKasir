import 'package:equatable/equatable.dart';

class PurchaseItem extends Equatable {
  final int? id;
  final int? purchaseId; // Nullable if creating before saving parent
  final int itemId;
  final int quantity;
  final int cost; // Cost per unit at time of purchase
  final List<String> serialNumbers;

  const PurchaseItem({
    this.id,
    this.purchaseId,
    required this.itemId,
    required this.quantity,
    required this.cost,
    this.serialNumbers = const [],
  });
  
  int get subtotal => quantity * cost;

  @override
  List<Object?> get props => [id, purchaseId, itemId, quantity, cost, serialNumbers];
}
