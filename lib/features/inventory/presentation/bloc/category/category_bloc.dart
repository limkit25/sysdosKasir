import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/inventory_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final InventoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await repository.getCategories(query: event.query);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }

  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await repository.addCategory(event.category);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (id) {
        emit(const CategoryOperationSuccess('Category added successfully'));
        add(LoadCategories());
      },
    );
  }

  Future<void> _onUpdateCategory(UpdateCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await repository.updateCategory(event.category);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {
        emit(const CategoryOperationSuccess('Category updated successfully'));
        add(LoadCategories());
      },
    );
  }

  Future<void> _onDeleteCategory(DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    final result = await repository.deleteCategory(event.id);
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (_) {
        emit(const CategoryOperationSuccess('Category deleted successfully'));
        add(LoadCategories());
      },
    );
  }
}
