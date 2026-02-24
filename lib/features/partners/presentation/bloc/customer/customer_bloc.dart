import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/partner_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';

@injectable
class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final PartnerRepository repository;

  CustomerBloc(this.repository) : super(CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<AddCustomer>(_onAddCustomer);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
  }

  Future<void> _onLoadCustomers(LoadCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await repository.getCustomers(query: event.query);
    result.fold(
      (failure) => emit(CustomerError(failure.message)),
      (customers) => emit(CustomerLoaded(customers)),
    );
  }

  Future<void> _onAddCustomer(AddCustomer event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await repository.addCustomer(event.customer);
    result.fold(
      (failure) => emit(CustomerError(failure.message)),
      (_) {
        emit(const CustomerOperationSuccess('Customer added successfully'));
        add(LoadCustomers());
      },
    );
  }

  Future<void> _onUpdateCustomer(UpdateCustomer event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    final result = await repository.updateCustomer(event.customer);
    result.fold(
      (failure) => emit(CustomerError(failure.message)),
      (_) {
        emit(const CustomerOperationSuccess('Customer updated successfully'));
        add(LoadCustomers());
      },
    );
  }

  Future<void> _onDeleteCustomer(DeleteCustomer event, Emitter<CustomerState> emit) async {
    // Optimistic update or reload? Let's reload for simplicity.
    // emit(CustomerLoading()); // Maybe don't emit loading for delete to avoid full screen spinner?
    // Let's keep it consistent.
    final result = await repository.deleteCustomer(event.id);
    result.fold(
      (failure) => emit(CustomerError(failure.message)),
      (_) {
        // emit(const CustomerOperationSuccess('Customer deleted successfully')); // Optional toast
        add(LoadCustomers());
      },
    );
  }
}
