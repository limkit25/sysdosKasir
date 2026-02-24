import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/item.dart';
import '../../../domain/entities/item_type_enum.dart';
import '../../../domain/repositories/inventory_repository.dart';
import '../../../domain/entities/item_composition.dart';
import 'item_event.dart';
import 'item_state.dart';

@injectable
class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final InventoryRepository repository;

  ItemBloc(this.repository) : super(ItemInitial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItemEvent>(_onAddItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);
    on<AddParentWithVariantsEvent>(_onAddParentWithVariants);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    
    final results = await Future.wait([
      repository.getItems(
        categoryId: event.categoryId,
        query: event.query,
        sortOption: event.sortOption,
        itemType: event.itemType,
      ),
      repository.getAvailableItemTypes(),
    ]);

    final itemsResult = results[0] as Either<Failure, List<Item>>;
    final typesResult = results[1] as Either<Failure, List<ItemType>>;

    itemsResult.fold(
      (failure) => emit(ItemError(failure.message)),
      (items) {
        final availableTypes = typesResult.getOrElse((_) => []);
        emit(ItemLoaded(items, availableTypes: availableTypes));
      },
    );
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    // Use repository's transactional addItem
    final result = await repository.addItem(event.item, compositions: event.compositions);
    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (_) {
        emit(const ItemOperationSuccess('Item added successfully'));
        add(const LoadItems());
      },
    );
  }

  Future<void> _onAddParentWithVariants(AddParentWithVariantsEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    final result = await repository.addParentWithVariants(event.parent, event.variants);
    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (_) {
        emit(const ItemOperationSuccess('Item with variants added successfully'));
        add(const LoadItems());
      },
    );
  }

  Future<void> _onUpdateItem(UpdateItemEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    // Use repository's transactional updateItem
    final result = await repository.updateItem(event.item, compositions: event.compositions);
    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (_) {
        emit(const ItemOperationSuccess('Item updated successfully'));
        add(const LoadItems());
      },
    );
  }

  Future<void> _onDeleteItem(DeleteItemEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    final result = await repository.deleteItem(event.id);
    result.fold(
      (failure) => emit(ItemError(failure.message)),
      (_) {
        emit(const ItemOperationSuccess('Item deleted successfully'));
        add(const LoadItems());
      },
    );
  }
}
