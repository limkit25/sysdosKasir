import 'package:equatable/equatable.dart';

class TransactionItem extends Equatable {
  final int? id;
  final int itemId;
  final int quantity;
  final int price;
  final int cost;
  final String itemName; // Helper for display
  final List<String> serialNumbers;

  const TransactionItem({
    this.id,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.cost,
    required this.itemName,
    this.serialNumbers = const [],
  });

  @override
  List<Object?> get props => [id, itemId, quantity, price, cost, itemName, serialNumbers];
}
