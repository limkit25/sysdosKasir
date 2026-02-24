import 'package:equatable/equatable.dart';
import '../../../inventory/domain/entities/item.dart';

class CartItem extends Equatable {
  final Item item;
  final int quantity;
  final List<String> serialNumbers;

  const CartItem({
    required this.item,
    required this.quantity,
    this.serialNumbers = const [],
  });

  int get price => item.price - item.discount;
  int get subtotal => item.price * quantity;

  CartItem copyWith({
    Item? item,
    int? quantity,
    List<String>? serialNumbers,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      serialNumbers: serialNumbers ?? this.serialNumbers,
    );
  }

  @override
  List<Object?> get props => [item, quantity, serialNumbers];
}
