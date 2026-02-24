import 'package:equatable/equatable.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/entities/item_type_enum.dart';

abstract class ItemState extends Equatable {
  const ItemState();
  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<Item> items;
  final List<ItemType> availableTypes;
  const ItemLoaded(this.items, {this.availableTypes = const []});
  @override
  List<Object?> get props => [items, availableTypes];
}

class ItemError extends ItemState {
  final String message;
  const ItemError(this.message);
  @override
  List<Object?> get props => [message];
}

class ItemOperationSuccess extends ItemState {
  final String message;
  const ItemOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
