import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/partner_repository.dart';
import 'supplier_event.dart';
import 'supplier_state.dart';

@injectable
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final PartnerRepository repository;

  SupplierBloc(this.repository) : super(SupplierInitial()) {
    on<LoadSuppliers>(_onLoadSuppliers);
    on<AddSupplier>(_onAddSupplier);
    on<UpdateSupplier>(_onUpdateSupplier);
    on<DeleteSupplier>(_onDeleteSupplier);
  }

  Future<void> _onLoadSuppliers(LoadSuppliers event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    final result = await repository.getSuppliers(query: event.query);
    result.fold(
      (failure) => emit(SupplierError(failure.message)),
      (suppliers) => emit(SupplierLoaded(suppliers)),
    );
  }

  Future<void> _onAddSupplier(AddSupplier event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    final result = await repository.addSupplier(event.supplier);
    result.fold(
      (failure) => emit(SupplierError(failure.message)),
      (_) {
        emit(const SupplierOperationSuccess('Supplier added successfully'));
        add(LoadSuppliers());
      },
    );
  }

  Future<void> _onUpdateSupplier(UpdateSupplier event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    final result = await repository.updateSupplier(event.supplier);
    result.fold(
      (failure) => emit(SupplierError(failure.message)),
      (_) {
        emit(const SupplierOperationSuccess('Supplier updated successfully'));
        add(LoadSuppliers());
      },
    );
  }

  Future<void> _onDeleteSupplier(DeleteSupplier event, Emitter<SupplierState> emit) async {
    final result = await repository.deleteSupplier(event.id);
    result.fold(
      (failure) => emit(SupplierError(failure.message)),
      (_) => add(LoadSuppliers()),
    );
  }
}
