import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/payment_method_repository.dart';
import 'payment_method_event.dart';
import 'payment_method_state.dart';

@injectable
class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final PaymentMethodRepository repository;

  PaymentMethodBloc(this.repository) : super(PaymentMethodLoading()) {
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<AddPaymentMethod>(_onAddPaymentMethod);
    on<DeletePaymentMethod>(_onDeletePaymentMethod);
    on<TogglePaymentMethod>(_onTogglePaymentMethod);
    on<ToggleFixPayment>(_onToggleFixPayment);
  }

  Future<void> _onLoadPaymentMethods(LoadPaymentMethods event, Emitter<PaymentMethodState> emit) async {
    emit(PaymentMethodLoading());
    final result = await repository.getPaymentMethods();
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (methods) => emit(PaymentMethodLoaded(methods)),
    );
  }

  Future<void> _onAddPaymentMethod(AddPaymentMethod event, Emitter<PaymentMethodState> emit) async {
    final result = await repository.addPaymentMethod(event.name);
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (_) => add(LoadPaymentMethods()),
    );
  }

  Future<void> _onDeletePaymentMethod(DeletePaymentMethod event, Emitter<PaymentMethodState> emit) async {
    final result = await repository.deletePaymentMethod(event.id);
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (_) => add(LoadPaymentMethods()),
    );
  }

  Future<void> _onTogglePaymentMethod(TogglePaymentMethod event, Emitter<PaymentMethodState> emit) async {
    final result = await repository.togglePaymentMethod(event.id, event.isActive);
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (_) => add(LoadPaymentMethods()),
    );
  }

  Future<void> _onToggleFixPayment(ToggleFixPayment event, Emitter<PaymentMethodState> emit) async {
    final result = await repository.toggleFixPayment(event.id, event.isFixPayment);
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (_) => add(LoadPaymentMethods()),
    );
  }
}
