import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final String? query;
  const LoadCategories({this.query});
  @override
  List<Object?> get props => [query];
}

class AddCategoryEvent extends CategoryEvent {
  final Category category;
  const AddCategoryEvent(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;
  const UpdateCategoryEvent(this.category);
  @override
  List<Object> get props => [category];
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;
  const DeleteCategoryEvent(this.id);
  @override
  List<Object> get props => [id];
}
