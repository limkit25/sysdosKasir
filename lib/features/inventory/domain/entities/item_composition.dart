import 'package:equatable/equatable.dart';

class ItemComposition extends Equatable {
  final int? id;
  final int parentItemId;
  final int childItemId;
  final int quantity;

  const ItemComposition({
    this.id,
    required this.parentItemId,
    required this.childItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, parentItemId, childItemId, quantity];
}
