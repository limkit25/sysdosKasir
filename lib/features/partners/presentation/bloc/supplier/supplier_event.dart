import 'package:equatable/equatable.dart';
import '../../../domain/entities/supplier.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();
  @override
  List<Object?> get props => [];
}

class LoadSuppliers extends SupplierEvent {
  final String? query;
  const LoadSuppliers({this.query});
  @override
  List<Object?> get props => [query];
}

class AddSupplier extends SupplierEvent {
  final Supplier supplier;
  const AddSupplier(this.supplier);
  @override
  List<Object?> get props => [supplier];
}

class UpdateSupplier extends SupplierEvent {
  final Supplier supplier;
  const UpdateSupplier(this.supplier);
  @override
  List<Object?> get props => [supplier];
}

class DeleteSupplier extends SupplierEvent {
  final int id;
  const DeleteSupplier(this.id);
  @override
  List<Object?> get props => [id];
}
