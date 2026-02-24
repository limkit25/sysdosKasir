import 'package:equatable/equatable.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/entities/item_composition.dart';
import '../../../domain/entities/sort_option_enum.dart';
import '../../../domain/entities/item_type_enum.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
  @override
  List<Object?> get props => [];
}

class LoadItems extends ItemEvent {
  final int? categoryId;
  final String? query;
  final SortOption sortOption;
  final ItemType? itemType;
  const LoadItems({this.categoryId, this.query, this.sortOption = SortOption.nameAsc, this.itemType});
  @override
  List<Object?> get props => [categoryId, query, sortOption, itemType];
}

class AddItemEvent extends ItemEvent {
  final Item item;
  final List<ItemComposition> compositions;
  const AddItemEvent(this.item, {this.compositions = const []});
  @override
  List<Object?> get props => [item, compositions];
}

class UpdateItemEvent extends ItemEvent {
  final Item item;
  final List<ItemComposition> compositions;
  const UpdateItemEvent(this.item, {this.compositions = const []});
  @override
  List<Object?> get props => [item, compositions];
}

class AddParentWithVariantsEvent extends ItemEvent {
  final Item parent;
  final List<Item> variants;
  const AddParentWithVariantsEvent(this.parent, this.variants);
  @override
  List<Object?> get props => [parent, variants];
}

class DeleteItemEvent extends ItemEvent {
  final int id;
  const DeleteItemEvent(this.id);
  @override
  List<Object?> get props => [id];
}
